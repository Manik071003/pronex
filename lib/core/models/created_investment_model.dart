class CreatedInvestment {
  final String id;
  final double amount;
  final int shares;
  final String accountName;
  final String accountNumber;
  final String ifsc;
  final String bankName;
  final String upiId;
  final String qrCodeUrl;

  const CreatedInvestment({
    required this.id,
    required this.amount,
    required this.shares,
    this.accountName = '',
    this.accountNumber = '',
    this.ifsc = '',
    this.bankName = '',
    this.upiId = '',
    this.qrCodeUrl = '',
  });

  factory CreatedInvestment.fromJson(Map<String, dynamic> json) {
    final root = _map(json['data']) ?? json;
    final investment = _map(root['investment']) ?? root;
    final payment =
        _map(root['paymentDetails']) ??
        _map(root['paymentInfo']) ??
        _map(root['payment']) ??
        _map(root['bankDetails']) ??
        _map(root['bank']) ??
        _map(root['companyBank']) ??
        _map(root['paymentAccount']) ??
        _map(root['settings']) ??
        _map(root['paymentSettings']) ??
        _map(investment['paymentDetails']) ??
        _map(investment['bankDetails']) ??
        _map(investment['settings']) ??
        _map(investment['paymentSettings']) ??
        investment;

    return CreatedInvestment(
      id: _value(investment, ['_id', 'id', 'investmentId']),
      amount:
          _toDouble(
            investment['finalAmount'] ??
                investment['amount'] ??
                investment['requestedAmount'] ??
                root['finalAmount'] ??
                root['amount'],
          ) ??
          0,
      shares: _toInt(investment['shares'] ?? investment['requestedShares']) ?? 0,
      accountName: _value(payment, [
        'accountName',
        'beneficiaryName',
        'name',
        'accountHolderName',
      ]),
      accountNumber: _value(payment, ['accountNumber', 'accNumber', 'account']),
      ifsc: _value(payment, ['ifsc', 'ifscCode', 'IFSC']),
      bankName: _value(payment, ['bankName', 'bank', 'bank_name']),
      upiId: _value(payment, ['upiId', 'upi', 'upiID', 'vpa']),
      qrCodeUrl: _value(payment, [
        'qrCode',
        'qr',
        'qrImage',
        'qrUrl',
        'qrCodeUrl',
        'upiQr',
      ]),
    );
  }

  static Map<String, dynamic>? _map(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _value(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is Map) {
        final nested = value['url'] ?? value['path'] ?? value['location'];
        if (nested != null && nested.toString().isNotEmpty) {
          return nested.toString();
        }
      } else if (value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return '';
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', ''));
    return null;
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
