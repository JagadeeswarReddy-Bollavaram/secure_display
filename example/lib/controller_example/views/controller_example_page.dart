import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller_example_controller.dart';
import '../../bank_details/widgets/info_card.dart';
import '../../bank_details/widgets/protection_status_card.dart';
import '../../bank_details/widgets/transaction_item.dart';
import '../../utils/secure_screen.dart';

/// Controller Example Page - Demonstrates SecureScreenController with GetX
class ControllerExamplePage extends GetView<ControllerExampleController> {
  const ControllerExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller Example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.delete<ControllerExampleController>();
            Navigator.pop(context);
          },
        ),
      ),
      body: GetBuilder<ControllerExampleController>(
        builder: (controller) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProtectionStatusCard(
                  isInitialized:
                      controller.secureScreenController.isInitialized,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                InfoCard(
                  label: 'Account Number',
                  value:
                      ScreenProtector.formatAccountNumber('9876543210987654'),
                  icon: Icons.account_balance,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Account Holder',
                  value: 'Jane Smith',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Account Type',
                  value: 'Current Account',
                  icon: Icons.account_box,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Balance',
                  value: '\$25,678.90',
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'IFSC Code',
                  value: 'BANK0005678',
                  icon: Icons.qr_code,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Branch',
                  value: 'Downtown Branch',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const TransactionItem(
                  description: 'Online Purchase',
                  amount: '-\$125.50',
                  date: 'Yesterday',
                ),
                const TransactionItem(
                  description: 'Interest Credit',
                  amount: '+\$45.20',
                  date: '3 days ago',
                ),
                const TransactionItem(
                  description: 'Bill Payment',
                  amount: '-\$89.99',
                  date: '1 week ago',
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Controller Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              controller.secureScreenController.isInitialized
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: controller
                                      .secureScreenController.isInitialized
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Initialized: ${controller.secureScreenController.isInitialized}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              controller.secureScreenController.isSecure
                                  ? Icons.lock
                                  : Icons.lock_open,
                              color: controller.secureScreenController.isSecure
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Screen Secured: ${controller.secureScreenController.isSecure}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
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
