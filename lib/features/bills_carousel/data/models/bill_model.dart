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

  /// Create BillModel from JSON
  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      maskedNumber: json['maskedNumber']?.toString() ?? '',
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : 0.0,
      status: json['status']?.toString() ?? '',
      bottomTagText: json['bottomTagText']?.toString() ?? '',
      footerText: json['footerText']?.toString() ?? '',
      flipperConfig: json['flipperConfig'] == true,
    );
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
