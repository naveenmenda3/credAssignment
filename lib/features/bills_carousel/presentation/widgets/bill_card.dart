import 'package:flutter/material.dart';
import '../../domain/entities/bill_entity.dart';
import 'flip_tag.dart';

/// Stateless bill card widget
class BillCard extends StatelessWidget {
  final BillEntity bill;

  const BillCard({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getGradientColor(bill.status).withOpacity(0.8),
            _getGradientColor(bill.status),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Bank icon and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBankIcon(),
                _buildStatusTag(),
              ],
            ),
            const SizedBox(height: 24),

            // Bank name
            Text(
              bill.bankName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Masked card number
            Text(
              bill.maskedNumber,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),

            // Amount
            Text(
              '₹${bill.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _getGradientColor(bill.status),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Flip tag
            FlipTag(
              bottomTagText: bill.bottomTagText,
              footerText: bill.footerText,
              flipperConfig: bill.flipperConfig,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.account_balance,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildStatusTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(bill.status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        bill.status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getGradientColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFF2196F3);
      case 'overdue':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green.shade700;
      case 'pending':
        return Colors.orange.shade700;
      case 'overdue':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
