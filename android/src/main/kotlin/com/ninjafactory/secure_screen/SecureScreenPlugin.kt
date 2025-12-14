package com.ninjafactory.secure_screen

import android.app.Activity
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** SecureScreenPlugin */
class SecureScreenPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var isRestricted: Boolean = false

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "secure_screen/screen_secure")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "restrict" -> {
                restrictScreenRecording()
                result.success(true)
            }
            "unrestrict" -> {
                unrestrictScreenRecording()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun restrictScreenRecording() {
        activity?.runOnUiThread {
            activity?.window?.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
            isRestricted = true
        }
    }

    private fun unrestrictScreenRecording() {
        activity?.runOnUiThread {
            activity?.window?.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            isRestricted = false
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        // If restriction was active before activity attachment, apply it now
        if (isRestricted) {
            restrictScreenRecording()
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        // Reapply restriction if it was active
        if (isRestricted) {
            restrictScreenRecording()
        }
    }

    override fun onDetachedFromActivity() {
        // Unrestrict when activity is detached
        if (isRestricted) {
            unrestrictScreenRecording()
        }
        activity = null
    }
}

