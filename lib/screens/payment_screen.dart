import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final selectedPaymentMethodProvider = StateProvider<String?>((ref) => null);

class PaymentScreen extends ConsumerWidget {
  final double totalAmount;
  final int itemCount;

  const PaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(selectedPaymentMethodProvider);
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCE4EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFCE4EC).withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Items: $itemCount',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Amount: ${currencyFormat.format(totalAmount)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Methods
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // UPI Section
                _buildSectionTitle('UPI'),
                _buildPaymentOption(
                  context,
                  ref,
                  'Google Pay',
                  'assets/icons/gpay.png',
                  'gpay',
                  selectedMethod,
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
                _buildPaymentOption(
                  context,
                  ref,
                  'PhonePe',
                  'assets/icons/phonepe.png',
                  'phonepe',
                  selectedMethod,
                  Icons.phone_android,
                  Colors.indigo,
                ),
                _buildPaymentOption(
                  context,
                  ref,
                  'Paytm',
                  'assets/icons/paytm.png',
                  'paytm',
                  selectedMethod,
                  Icons.payment,
                  Colors.blue,
                ),

                const SizedBox(height: 16),

                // Credit/Debit Cards
                _buildSectionTitle('Credit / Debit Cards'),
                _buildPaymentOption(
                  context,
                  ref,
                  'Add New Card',
                  'assets/icons/card.png',
                  'card',
                  selectedMethod,
                  Icons.credit_card,
                  Colors.black87,
                ),

                const SizedBox(height: 16),

                // Net Banking
                _buildSectionTitle('Net Banking'),
                _buildPaymentOption(
                  context,
                  ref,
                  'HDFC Bank',
                  'assets/icons/hdfc.png',
                  'hdfc',
                  selectedMethod,
                  Icons.account_balance,
                  Colors.red,
                ),
                _buildPaymentOption(
                  context,
                  ref,
                  'ICICI Bank',
                  'assets/icons/icici.png',
                  'icici',
                  selectedMethod,
                  Icons.account_balance,
                  Colors.orange,
                ),
                _buildPaymentOption(
                  context,
                  ref,
                  'SBI Bank',
                  'assets/icons/sbi.png',
                  'sbi',
                  selectedMethod,
                  Icons.account_balance,
                  Colors.blue,
                ),
                _buildPaymentOption(
                  context,
                  ref,
                  'Axis Bank',
                  'assets/icons/axis.png',
                  'axis',
                  selectedMethod,
                  Icons.account_balance,
                  Colors.purple,
                ),

                const SizedBox(height: 16),

                // Cash on Delivery
                _buildSectionTitle('Other Methods'),
                _buildPaymentOption(
                  context,
                  ref,
                  'Cash on Delivery',
                  'assets/icons/cod.png',
                  'cod',
                  selectedMethod,
                  Icons.money,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Pay Now Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: selectedMethod == null
                  ? null
                  : () {
                // Process payment
                _showPaymentSuccessDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                'Pay ${currencyFormat.format(totalAmount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context,
      WidgetRef ref,
      String title,
      String imagePath,
      String value,
      String? selectedMethod,
      IconData fallbackIcon,
      Color iconColor,
      ) {
    final isSelected = selectedMethod == value;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFFE91E63) : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          ref.read(selectedPaymentMethodProvider.notifier).state = value;
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  fallbackIcon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFE91E63) : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                  child: Icon(
                    Icons.circle,
                    size: 12,
                    color: Color(0xFFE91E63),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}