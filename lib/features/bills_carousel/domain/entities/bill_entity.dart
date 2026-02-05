/// Domain-level immutable entity representing a bill
class BillEntity {
  final String id;
  final String bankName;
  final String maskedNumber;
  final double amount;
  final String status;
  final String bottomTagText;
  final String footerText;
  final bool flipperConfig;

  const BillEntity({
    required this.id,
    required this.bankName,
    required this.maskedNumber,
    required this.amount,
    required this.status,
    required this.bottomTagText,
    required this.footerText,
    required this.flipperConfig,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BillEntity &&
        other.id == id &&
        other.bankName == bankName &&
        other.maskedNumber == maskedNumber &&
        other.amount == amount &&
        other.status == status &&
        other.bottomTagText == bottomTagText &&
        other.footerText == footerText &&
        other.flipperConfig == flipperConfig;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        bankName.hashCode ^
        maskedNumber.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        bottomTagText.hashCode ^
        footerText.hashCode ^
        flipperConfig.hashCode;
  }
}
