class KycReviewData {
  final KycPersonalData personal;
  final KycIdentityData pan;
  final KycIdentityData aadhaar;
  final KycNomineeData nominee;
  final KycBankData bank;

  const KycReviewData({
    required this.personal,
    required this.pan,
    required this.aadhaar,
    required this.nominee,
    required this.bank,
  });

  factory KycReviewData.fromJson(Map<String, dynamic> json) {
    final source = _map(json['data']) ?? _map(json['kyc']) ?? json;
    return KycReviewData(
      personal: KycPersonalData.fromJson(
        _section(source, ['personal', 'personalInfo', 'basic']),
      ),
      pan: KycIdentityData.fromJson(
        _section(source, ['pan', 'panVerification']),
      ),
      aadhaar: KycIdentityData.fromJson(
        _section(source, ['aadhaar', 'aadhaarVerification']),
      ),
      nominee: KycNomineeData.fromJson(
        _section(source, ['nominee', 'nomineeVerification']),
      ),
      bank: KycBankData.fromJson(
        _section(source, ['bank', 'bankVerification']),
      ),
    );
  }

  static Map<String, dynamic> _section(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = _map(source[key]);
      if (value != null) return value;
    }
    return source;
  }

  static Map<String, dynamic>? _map(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

class KycPersonalData {
  final String fullName;
  final String email;
  final String dob;
  final String address;

  const KycPersonalData({
    this.fullName = '',
    this.email = '',
    this.dob = '',
    this.address = '',
  });

  factory KycPersonalData.fromJson(Map<String, dynamic> json) =>
      KycPersonalData(
        fullName: _value(json, ['fullName', 'name']),
        email: _value(json, ['email']),
        dob: _value(json, ['dob', 'dateOfBirth']),
        address: _value(json, ['address', 'residentialAddress']),
      );
}

class KycIdentityData {
  final String number;
  final String documentType;
  final String document;

  const KycIdentityData({
    this.number = '',
    this.documentType = '',
    this.document = '',
  });

  factory KycIdentityData.fromJson(Map<String, dynamic> json) =>
      KycIdentityData(
        number: _value(json, ['panNumber', 'aadhaarNumber', 'number']),
        documentType: _value(json, ['documentType', 'type']),
        document: _value(json, ['document', 'documentUrl', 'image', 'file']),
      );
}

class KycNomineeData {
  final String name;
  final String pan;
  final String aadhaar;
  final String dob;

  const KycNomineeData({
    this.name = '',
    this.pan = '',
    this.aadhaar = '',
    this.dob = '',
  });

  factory KycNomineeData.fromJson(Map<String, dynamic> json) => KycNomineeData(
    name: _value(json, ['name', 'nomineeName']),
    pan: _value(json, ['pan', 'panNumber', 'nomineePan']),
    aadhaar: _value(json, ['aadhaar', 'aadhaarNumber', 'nomineeAadhaar']),
    dob: _value(json, ['dob', 'dateOfBirth', 'nomineeDob']),
  );
}

class KycBankData {
  final String beneficiaryName;
  final String accountNumber;
  final String branch;
  final String ifsc;
  final String document;

  const KycBankData({
    this.beneficiaryName = '',
    this.accountNumber = '',
    this.branch = '',
    this.ifsc = '',
    this.document = '',
  });

  factory KycBankData.fromJson(Map<String, dynamic> json) => KycBankData(
    beneficiaryName: _value(json, ['beneficiaryName', 'name']),
    accountNumber: _value(json, ['accountNumber']),
    branch: _value(json, ['branch', 'branchName']),
    ifsc: _value(json, ['ifsc', 'ifscCode']),
    document: _value(json, ['document', 'documentUrl', 'image', 'file']),
  );
}

String _value(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    if (value is Map) {
      final nested = value['url'] ?? value['path'] ?? value['location'];
      if (nested != null) return nested.toString();
    } else if (value.toString().isNotEmpty) {
      return value.toString();
    }
  }
  return '';
}
