import 'package:flutter/material.dart';
import '../../domain/entities/bill_entity.dart';
import 'flip_tag.dart';

/// CRED-style minimalist bill card widget
class BillCard extends StatelessWidget {
  final BillEntity bill;
  final bool isCarouselMode;

  const BillCard({
    super.key,
    required this.bill,
    this.isCarouselMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row: Bank icon + name + Pay button
            Row(
              children: [
                // Bank icon
                _buildBankIcon(),
                const SizedBox(width: 12),
                
                // Bank name and masked number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.bankName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (bill.maskedNumber.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          bill.maskedNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Pay button
                _buildPayButton(),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Bottom: Status tag or flip tag
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getBrandColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          bill.bankName.isNotEmpty ? bill.bankName[0].toUpperCase() : 'B',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _getBrandColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Pay ₹${_formatAmount(bill.amount)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 2)}K';
    }
    return amount.toStringAsFixed(2);
  }

  Color _getBrandColor() {
    // Simple color mapping based on bank name
    final name = bill.bankName.toLowerCase();
    if (name.contains('hdfc')) return const Color(0xFFED1C24);
    if (name.contains('icici')) return const Color(0xFFFF6600);
    if (name.contains('sbi')) return const Color(0xFF22409A);
    if (name.contains('axis')) return const Color(0xFF800000);
    if (name.contains('vil')) return const Color(0xFFE60000);
    return const Color(0xFF1976D2);
  }
}
