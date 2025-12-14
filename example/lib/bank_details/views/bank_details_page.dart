import 'package:flutter/material.dart';
import '../../utils/secure_screen.dart';
import '../controllers/bank_details_controller.dart';
import '../widgets/info_card.dart';
import '../widgets/protection_status_card.dart';
import '../widgets/transaction_item.dart';

/// Second Page - Bank Details (with Screen Restriction)
class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  late BankDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BankDetailsController();
    _controller.initializeRestriction();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
      ),
      body: StreamBuilder<bool>(
        stream: _controller.isInitializedStream,
        initialData: false,
        builder: (context, snapshot) {
          final isInitialized = snapshot.data ?? false;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProtectionStatusCard(isInitialized: isInitialized),
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
                        ScreenProtector.formatAccountNumber('1234567890123456'),
                    icon: Icons.account_balance,
                  ),
                  const SizedBox(height: 16),
                  const InfoCard(
                    label: 'Account Holder',
                    value: 'John Doe',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  const InfoCard(
                    label: 'Account Type',
                    value: 'Savings Account',
                    icon: Icons.account_box,
                  ),
                  const SizedBox(height: 16),
                  const InfoCard(
                    label: 'Balance',
                    value: '\$12,345.67',
                    icon: Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const InfoCard(
                    label: 'IFSC Code',
                    value: 'BANK0001234',
                    icon: Icons.qr_code,
                  ),
                  const SizedBox(height: 16),
                  const InfoCard(
                    label: 'Branch',
                    value: 'Main Street Branch',
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
                    description: 'Payment to ABC Store',
                    amount: '-\$50.00',
                    date: 'Today',
                  ),
                  const TransactionItem(
                    description: 'Salary Credit',
                    amount: '+\$5,000.00',
                    date: '2 days ago',
                  ),
                  const TransactionItem(
                    description: 'ATM Withdrawal',
                    amount: '-\$200.00',
                    date: '5 days ago',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
