import '../../domain/entities/bill_entity.dart';

/// Data model for Bill with JSON serialization
class BillModel extends BillEntity {
  const BillModel({
    required super.id,
    required super.bankName,
    required super.maskedNumber,
    required super.amount,
    required super.status,
    required super.bottomTagText,
    required super.footerText,
    required super.flipperConfig,
  });

  /// Create BillModel from CRED API JSON structure
  factory BillModel.fromJson(Map<String, dynamic> json) {
    try {
      // Extract template_properties.body
      final templateProps = json['template_properties'] as Map<String, dynamic>?;
      final body = templateProps?['body'] as Map<String, dynamic>?;
      
      if (body == null) {
        throw Exception('Missing template_properties.body in API response');
      }

      // Extract logo information
      final logo = body['logo'] as Map<String, dynamic>?;
      final logoUrl = logo?['url']?.toString() ?? '';
      
      // Extract bank name from logo URL or use a default
      String bankName = _extractBankNameFromUrl(logoUrl);
      
      // Extract bill details
      final billDetails = body['bill_details'] as Map<String, dynamic>?;
      final maskedNumber = billDetails?['masked_number']?.toString() ?? '';
      
      // Extract amount from CTA text (e.g., "Pay ₹200" or "Pay ₹45,000")
      final ctaText = body['cta']?['text']?.toString() ?? '';
      final amount = _extractAmountFromCta(ctaText);
      
      // Extract footer and bottom tag text
      final footerText = body['footer_text']?.toString() ?? '';
      final bottomTagText = body['bottom_tag_text']?.toString() ?? footerText;
      
      // Check if flipper is enabled
      final flipperConfig = body['flipper_config'] as Map<String, dynamic>?;
      final isFlipEnabled = flipperConfig?['enabled'] == true;
      
      // Determine status from footer text
      final status = _determineStatus(footerText);
      
      // Use external_id as unique ID
      final id = json['external_id']?.toString() ?? '';

      return BillModel(
        id: id,
        bankName: bankName,
        maskedNumber: maskedNumber,
        amount: amount,
        status: status,
        bottomTagText: bottomTagText,
        footerText: footerText,
        flipperConfig: isFlipEnabled,
      );
    } catch (e) {
      // Fallback: try simple structure for backward compatibility
      return BillModel(
        id: json['id']?.toString() ?? '',
        bankName: json['bankName']?.toString() ?? 'Unknown',
        maskedNumber: json['maskedNumber']?.toString() ?? '',
        amount: (json['amount'] is num)
            ? (json['amount'] as num).toDouble()
            : 0.0,
        status: json['status']?.toString() ?? 'pending',
        bottomTagText: json['bottomTagText']?.toString() ?? '',
        footerText: json['footerText']?.toString() ?? '',
        flipperConfig: json['flipperConfig'] == true,
      );
    }
  }

  /// Extract bank name from logo URL
  static String _extractBankNameFromUrl(String url) {
    if (url.isEmpty) return 'Bank';
    
    // Common bank identifiers in URLs
    if (url.contains('hdfc')) return 'HDFC Bank';
    if (url.contains('icici')) return 'ICICI Bank';
    if (url.contains('sbi')) return 'SBI';
    if (url.contains('axis')) return 'Axis Bank';
    if (url.contains('kotak')) return 'Kotak Bank';
    if (url.contains('vil') || url.contains('vodafone')) return 'VI';
    if (url.contains('airtel')) return 'Airtel';
    if (url.contains('jio')) return 'Jio';
    
    // Default
    return 'Service Provider';
  }

  /// Extract amount from CTA text like "Pay ₹200" or "Pay ₹45,000"
  static double _extractAmountFromCta(String ctaText) {
    if (ctaText.isEmpty) return 0.0;
    
    // Remove "Pay ₹" and commas, then parse
    final amountStr = ctaText
        .replaceAll('Pay ₹', '')
        .replaceAll('PAY ₹', '')
        .replaceAll(',', '')
        .trim();
    
    return double.tryParse(amountStr) ?? 0.0;
  }

  /// Determine status from footer text
  static String _determineStatus(String footerText) {
    final lower = footerText.toLowerCase();
    if (lower.contains('overdue')) return 'overdue';
    if (lower.contains('due today') || lower.contains('today')) return 'due_today';
    if (lower.contains('paid')) return 'paid';
    return 'pending';
  }

  /// Convert BillModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'maskedNumber': maskedNumber,
      'amount': amount,
      'status': status,
      'bottomTagText': bottomTagText,
      'footerText': footerText,
      'flipperConfig': flipperConfig,
    };
  }

  /// Convert BillModel to BillEntity
  BillEntity toEntity() {
    return BillEntity(
      id: id,
      bankName: bankName,
      maskedNumber: maskedNumber,
      amount: amount,
      status: status,
      bottomTagText: bottomTagText,
      footerText: footerText,
      flipperConfig: flipperConfig,
    );
  }

  /// Create BillModel from BillEntity
  factory BillModel.fromEntity(BillEntity entity) {
    return BillModel(
      id: entity.id,
      bankName: entity.bankName,
      maskedNumber: entity.maskedNumber,
      amount: entity.amount,
      status: entity.status,
      bottomTagText: entity.bottomTagText,
      footerText: entity.footerText,
      flipperConfig: entity.flipperConfig,
    );
  }
}
