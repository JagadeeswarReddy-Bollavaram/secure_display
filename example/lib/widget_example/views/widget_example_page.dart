import 'package:flutter/material.dart';
import 'package:secure_screen/secure_screen.dart';
import '../../bank_details/widgets/info_card.dart';
import '../../bank_details/widgets/protection_status_card.dart';
import '../../bank_details/widgets/transaction_item.dart';
import '../../utils/secure_screen.dart';

/// Widget Example Page - Demonstrates SecureScreenWidget
/// The screen restriction is automatically managed by the widget lifecycle
class WidgetExamplePage extends StatelessWidget {
  const WidgetExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // SecureScreenWidget automatically activates restriction when mounted
    // and disposes it when unmounted
    return SecureScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Example'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProtectionStatusCard(isInitialized: true),
                const SizedBox(height: 16),
                Card(
                  color: Colors.blue.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Automatic Protection',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'This page uses SecureScreenWidget which automatically:',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Activates screen restriction when the widget is mounted',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Disposes restriction when the widget is removed',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• No manual lifecycle management needed!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
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
                      ScreenProtector.formatAccountNumber('5555666677778888'),
                  icon: Icons.account_balance,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Account Holder',
                  value: 'Alice Johnson',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Account Type',
                  value: 'Premium Savings',
                  icon: Icons.account_box,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Balance',
                  value: '\$50,123.45',
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'IFSC Code',
                  value: 'BANK0009999',
                  icon: Icons.qr_code,
                ),
                const SizedBox(height: 16),
                const InfoCard(
                  label: 'Branch',
                  value: 'Central Plaza Branch',
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
                  description: 'Investment Deposit',
                  amount: '+\$10,000.00',
                  date: 'Today',
                ),
                const TransactionItem(
                  description: 'Online Transfer',
                  amount: '-\$500.00',
                  date: 'Yesterday',
                ),
                const TransactionItem(
                  description: 'Interest Credit',
                  amount: '+\$250.75',
                  date: '3 days ago',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
