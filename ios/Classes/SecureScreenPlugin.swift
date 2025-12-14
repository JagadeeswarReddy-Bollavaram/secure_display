import Flutter
import UIKit
import ObjectiveC

/// Transparent view that forwards all touches to Flutter view
/// Added at window level to ensure touches reach Flutter
private class TouchPassthroughView: UIView {
    weak var targetView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Always forward to target view (Flutter view)
        if let target = targetView {
            let pointInTarget = convert(point, to: target)
            return target.hitTest(pointInTarget, with: event)
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Only claim point if it's inside target view
        if let target = targetView {
            let pointInTarget = convert(point, to: target)
            return target.bounds.contains(pointInTarget)
        }
        return false
    }
}

public class SecureScreenPlugin: NSObject, FlutterPlugin {
    private var isRestricted: Bool = false
    private var screenRecordingObserver: NSObjectProtocol?
    private var screenshotObserver: NSObjectProtocol?
    private var currentWindow: UIWindow?
    
    // --- Security Views ---
    // 1. Permanent, hidden view for screenshot/task switcher protection (User sees CLEAR content)
    private var secureLayerProtectionView: UIView?
    // 2. Dynamic, visible black overlay for active screen recording detection (User sees BLACK content)
    private var dynamicBlurOverlay: UIView?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "secure_display/screen_secure",
            binaryMessenger: registrar.messenger()
        )
        let instance = SecureScreenPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "restrict":
            secureScreen()
            result(true)
        case "unrestrict":
            unsecureScreen()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func secureScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let window: UIWindow?

            if #available(iOS 13.0, *) {
                window = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first?.windows.first
            } else {
                window = UIApplication.shared.keyWindow
            }

            guard let window = window else {
                self.isRestricted = true
                return
            }
            
            // Store window reference
            self.currentWindow = window
            
            // --- 1. Activate Passive Screenshot/Task Switcher Protection (CLEAR view) ---
            self.addSecureLayerProtection(to: window)
            
            // --- 2. Activate Active Screen Recording Protection (DYNAMIC blur) ---
            if #available(iOS 11.0, *) {
                self.startMonitoringScreenRecording()
                // Check if recording is already active upon entering the screen
                if UIScreen.main.isCaptured {
                    self.showDynamicBlurOverlay(in: window)
                }
            }
            
            
            self.isRestricted = true
        }
    }
    
    private func unsecureScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removeSecureLayerProtection()
            self.removeDynamicBlurOverlay()
            self.stopMonitoringScreenRecording()
            self.currentWindow = nil
            self.isRestricted = false
        }
    }
    
    // MARK: - Passive Protection (Screenshot & Task Switcher)
    
    /// Adds a secure text entry view covering the entire window.
    /// Uses the EXACT SwiftUI approach from Stack Overflow (ProtonFission)
    /// Matches _CaptureProtectedContainer implementation exactly.
    /// 
    /// Key difference: In SwiftUI, content is added INSIDE secure subview via UIHostingController.
    /// For Flutter, we add Flutter's root view INSIDE the secure subview.
    /// 
    private func addSecureLayerProtection(to window: UIWindow) {
        // 1. Remove any existing security view
        removeSecureLayerProtection()
        
        // 2. Get secure subview (matches SwiftUI secureCaptureView approach)
        let field = UITextField()
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false
        
        // Create temporary container to trigger subview creation
        let tempContainer = UIView(frame: CGRect.zero)
        tempContainer.addSubview(field)
        tempContainer.layoutIfNeeded()
        
        // Get secure subview (matches: return tf.subviews.first ?? UIView())
        guard let secure = field.subviews.first else {
            // Fallback if subview doesn't exist
            field.removeFromSuperview()
            field.alpha = 0.01
        field.backgroundColor = .clear
        window.addSubview(field)
            field.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                field.topAnchor.constraint(equalTo: window.topAnchor),
                field.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                field.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                field.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
            self.secureLayerProtectionView = field
            window.layoutIfNeeded()
            return
        }
        
        // Remove field from temp container
        field.removeFromSuperview()
        
        // 3. CRITICAL: Configure secure subview
        secure.backgroundColor = .clear
        secure.alpha = 1.0  // Fully opaque - subview itself is invisible but needs to be opaque for subviews to be visible
        secure.isUserInteractionEnabled = false  // Secure subview doesn't handle touches
        
        // 4. CRITICAL: Get Flutter's root view (equivalent to SwiftUI's host.view)
        // In SwiftUI: let host = UIHostingController(rootView: content)
        // For Flutter: Get the root view controller's view
        guard let rootViewController = window.rootViewController else {
            // No root view controller - can't proceed
            return
        }
        
        let flutterView = rootViewController.view
        
        // 5. CRITICAL: Add Flutter view INSIDE secure subview (like SwiftUI does)
        // In SwiftUI: secure.addSubview(host.view)
        // This is the key - content must be INSIDE secure subview!
        flutterView!.backgroundColor = .clear
        flutterView!.alpha = 1.0  // Ensure Flutter view is fully visible
        flutterView!.translatesAutoresizingMaskIntoConstraints = false
        flutterView!.isUserInteractionEnabled = true  // Ensure Flutter view can receive touches
        
        // CRITICAL: Store the original parent before moving Flutter view
        // This is essential for proper restoration
        let originalParent = flutterView!.superview ?? window
        objc_setAssociatedObject(secure, "originalFlutterParent", originalParent, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Remove Flutter view from its current parent first
        flutterView!.removeFromSuperview()
        
        // Add Flutter view INSIDE secure subview
        secure.addSubview(flutterView! )
        
        // CRITICAL: Create transparent passthrough view at window level to forward touches
        // This must be added AFTER secure subview so it's on top
        let touchPassthrough = TouchPassthroughView()
        touchPassthrough.backgroundColor = .clear
        touchPassthrough.isUserInteractionEnabled = true
        touchPassthrough.targetView = flutterView!
        
        // 5. Set constraints to fill secure subview
        NSLayoutConstraint.activate([
            flutterView!.topAnchor.constraint(equalTo: secure.topAnchor),
            flutterView!.bottomAnchor.constraint(equalTo: secure.bottomAnchor),
            flutterView!.leadingAnchor.constraint(equalTo: secure.leadingAnchor),
            flutterView!.trailingAnchor.constraint(equalTo: secure.trailingAnchor)
        ])
        
        // 7. Add secure subview to window
        window.addSubview(secure)
        
        // Position secure subview to cover entire window
        secure.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secure.topAnchor.constraint(equalTo: window.topAnchor),
            secure.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            secure.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            secure.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        // 7b. Add touch passthrough view on top to forward touches
        window.addSubview(touchPassthrough)
        window.bringSubviewToFront(touchPassthrough)
        touchPassthrough.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            touchPassthrough.topAnchor.constraint(equalTo: window.topAnchor),
            touchPassthrough.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            touchPassthrough.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            touchPassthrough.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
        
        // 8. Keep references
        self.secureLayerProtectionView = secure
        
        // Store field to prevent deallocation (subview needs parent field)
        objc_setAssociatedObject(secure, "secureTextField", field, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Store Flutter view reference for cleanup
        objc_setAssociatedObject(secure, "flutterView", flutterView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Store touch passthrough view for cleanup
        objc_setAssociatedObject(secure, "touchPassthrough", touchPassthrough, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Force layout
        window.layoutIfNeeded()
    }
    
    private func removeSecureLayerProtection() {
        guard let secureView = self.secureLayerProtectionView else { return }
        
        // Remove touch passthrough view
        if let touchPassthrough = objc_getAssociatedObject(secureView, "touchPassthrough") as? UIView {
            touchPassthrough.removeFromSuperview()
            objc_setAssociatedObject(secureView, "touchPassthrough", nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else if let window = currentWindow {
            // Fallback: search window subviews
            for subview in window.subviews {
                if subview is TouchPassthroughView {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
        
        // CRITICAL: Restore Flutter view to its original parent before removing secure view
        guard let window = currentWindow,
              let rootViewController = window.rootViewController else {
            secureView.removeFromSuperview()
            self.secureLayerProtectionView = nil
            return
        }
        
        // Get Flutter view from associations or search secure subview's subviews
        var flutterView: UIView? = objc_getAssociatedObject(secureView, "flutterView") as? UIView
        
        // Fallback: Search secure subview's subviews for Flutter view
        if flutterView == nil {
            for subview in secureView.subviews {
                // Flutter view is likely the largest subview (full screen)
                if subview.frame.width > 100 && subview.frame.height > 100 {
                    flutterView = subview
                    break
                }
            }
        }
        
        // Last resort: Use root VC view directly
        guard let flutterView = flutterView else {
            secureView.removeFromSuperview()
            self.secureLayerProtectionView = nil
            return
        }
        
        // Restore Flutter view based on whether it's the root VC view
        if flutterView === rootViewController.view {
            // Special case: Flutter view is the root view controller's view
            flutterView.removeFromSuperview()
            window.addSubview(flutterView)
            flutterView.frame = window.bounds
            flutterView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                flutterView.topAnchor.constraint(equalTo: window.topAnchor),
                flutterView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                flutterView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                flutterView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        } else {
            // Normal case: Restore to original parent
            if let originalParent = objc_getAssociatedObject(secureView, "originalFlutterParent") as? UIView {
                flutterView.removeFromSuperview()
                originalParent.addSubview(flutterView)
                flutterView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    flutterView.topAnchor.constraint(equalTo: originalParent.topAnchor),
                    flutterView.leadingAnchor.constraint(equalTo: originalParent.leadingAnchor),
                    flutterView.trailingAnchor.constraint(equalTo: originalParent.trailingAnchor),
                    flutterView.bottomAnchor.constraint(equalTo: originalParent.bottomAnchor)
                ])
                originalParent.layoutIfNeeded()
            } else {
                // Fallback: Add to window
                flutterView.removeFromSuperview()
                window.addSubview(flutterView)
                flutterView.frame = window.bounds
            }
        }
        
        // Force layout and cleanup
        window.layoutIfNeeded()
        objc_setAssociatedObject(secureView, "flutterView", nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(secureView, "originalFlutterParent", nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Remove secure subview
        secureView.removeFromSuperview()
        
        // Release associated text field
        if let field = objc_getAssociatedObject(secureView, "secureTextField") as? UITextField {
            if field.superview != nil {
                field.removeFromSuperview()
            }
            objc_setAssociatedObject(secureView, "secureTextField", nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        self.secureLayerProtectionView = nil
    }
    
    // MARK: - Active Protection (Screen Recording)
    
    @available(iOS 11.0, *)
    private func startMonitoringScreenRecording() {
        // Monitor for screen recording state changes
        screenRecordingObserver = NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleScreenRecordingChange()
        }
    }
    
    private func stopMonitoringScreenRecording() {
        if let observer = screenRecordingObserver {
            NotificationCenter.default.removeObserver(observer)
            screenRecordingObserver = nil
        }
    }
    
    @available(iOS 11.0, *)
    private func handleScreenRecordingChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let window = self.currentWindow, self.isRestricted else { return }
        
        if UIScreen.main.isCaptured {
                // Screen recording is active - show black overlay
                self.showDynamicBlurOverlay(in: window)
            } else {
                // Screen recording stopped - remove black overlay
                self.removeDynamicBlurOverlay()
            }
        }
    }
    
    private func showDynamicBlurOverlay(in window: UIWindow) {
        // Remove existing overlay if any
        removeDynamicBlurOverlay()
        
        // Create black overlay
        let blackOverlay = UIView(frame: window.bounds)
        blackOverlay.backgroundColor = .black
        blackOverlay.isUserInteractionEnabled = false
        blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add to window on top of everything
        window.addSubview(blackOverlay)
        window.bringSubviewToFront(blackOverlay)
        self.dynamicBlurOverlay = blackOverlay
    }
    
    private func removeDynamicBlurOverlay() {
        self.dynamicBlurOverlay?.removeFromSuperview()
        self.dynamicBlurOverlay = nil
    }
    
    
    deinit {
        stopMonitoringScreenRecording()
        removeSecureLayerProtection()
        removeDynamicBlurOverlay()
    }
}

