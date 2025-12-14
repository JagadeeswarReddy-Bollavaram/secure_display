import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../bank_details/views/bank_details_page.dart';
import '../../controller_example/controllers/controller_example_controller.dart';
import '../../controller_example/views/controller_example_page.dart';
import '../../profile/views/profile_page.dart';
import '../../widget_example/views/widget_example_page.dart';
import '../../navigation_example/views/navigation_test_page.dart';
import '../widgets/profile_icon_button.dart';

/// Home Page - Choose between Class or Controller implementation
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Protector Examples'),
        actions: [
          ProfileIconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.security,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              const Text(
                'Screen Protection Examples',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BankDetailsPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.code,
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'SecureScreen Class',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // Put the controller before navigating
                    Get.put(ControllerExampleController());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ControllerExamplePage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          size: 48,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'SecureScreenController',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WidgetExamplePage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.widgets,
                          size: 48,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'SecureScreenWidget',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NavigationTestPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.navigation,
                          size: 48,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Navigation Test',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
