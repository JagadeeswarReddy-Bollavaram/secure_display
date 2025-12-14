import 'package:flutter/material.dart';
import 'package:secure_display/secure_display.dart';

/// Navigation Test Page - Demonstrates how SecureScreenWidget behaves during navigation
class NavigationTestPage extends StatelessWidget {
  const NavigationTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Page (With Widget)'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'This page uses SecureScreenWidget',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Screen restriction is ACTIVE',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 48),
                Card(
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Navigation Behavior:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '• Using Navigator.push():',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '  - This page stays in widget tree',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '  - SecureScreenWidget remains mounted',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '  - Restriction stays ACTIVE on new page',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '• Using Navigator.pushReplacement():',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '  - This page is removed from tree',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '  - SecureScreenWidget is disposed',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '  - Restriction is REMOVED on new page',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    // Using push - original page stays in tree
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NextPageWithoutWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Push Next Page (No Widget)'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Using pushReplacement - original page is removed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NextPageWithoutWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Replace with Next Page'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Using push - but new page also has widget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NextPageWithWidget(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.security),
                  label: const Text('Push Next Page (With Widget)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Next page WITHOUT SecureScreenWidget
class NextPageWithoutWidget extends StatelessWidget {
  const NextPageWithoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page (No Widget)'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_open,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                'This page does NOT use SecureScreenWidget',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.orange.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Screen Restriction Status:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'If you navigated with push():',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '→ Restriction is STILL ACTIVE',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'If you navigated with pushReplacement():',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '→ Restriction is REMOVED',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Next page WITH SecureScreenWidget
class NextPageWithWidget extends StatelessWidget {
  const NextPageWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SecureScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Next Page (With Widget)'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'This page ALSO uses SecureScreenWidget',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Screen restriction is ACTIVE',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Best Practice:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Each secure page should have its own SecureScreenWidget to ensure protection regardless of navigation method.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
