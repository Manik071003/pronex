class PortfolioSummary {
  final double totalInvested;
  final double currentValue;
  final int sharesOwned;
  final double expectedReturn;
  final double rentalIncome;

  PortfolioSummary({
    required this.totalInvested,
    required this.currentValue,
    required this.sharesOwned,
    required this.expectedReturn,
    required this.rentalIncome,
  });

  factory PortfolioSummary.empty() {
    return PortfolioSummary(
      totalInvested: 0,
      currentValue: 0,
      sharesOwned: 0,
      expectedReturn: 0,
      rentalIncome: 0,
    );
  }

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalInvested: _toDouble(json['totalInvested']),
      currentValue: _toDouble(json['currentValue']),
      sharesOwned: _toInt(json['sharesOwned']),
      expectedReturn: _toDouble(json['expectedReturn']),
      rentalIncome: _toDouble(json['rentalIncome']),
    );
  }

  String get formattedTotalInvested => _formatInr(totalInvested);

  String get formattedCurrentValue => _formatInr(currentValue);

  String get formattedRentalIncome => _formatInr(rentalIncome);

  String get formattedSharesOwned => sharesOwned.toString();

  String get formattedExpectedReturn =>
      '${expectedReturn.toStringAsFixed(expectedReturn % 1 == 0 ? 0 : 1)}%';
}

class PortfolioDocument {
  final String type;
  final String name;
  final String? property;
  final String url;

  PortfolioDocument({
    required this.type,
    required this.name,
    this.property,
    required this.url,
  });

  factory PortfolioDocument.fromJson(Map<String, dynamic> json) {
    return PortfolioDocument(
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Document',
      property: json['property']?.toString(),
      url: json['url']?.toString() ?? '',
    );
  }
}

class PortfolioKycDetails {
  final String fullName;
  final String email;
  final String dob;
  final String address;
  final String panNumber;
  final String aadhaarNumber;
  final Map<String, dynamic> nominee;
  final Map<String, dynamic> bank;

  PortfolioKycDetails({
    required this.fullName,
    required this.email,
    required this.dob,
    required this.address,
    required this.panNumber,
    required this.aadhaarNumber,
    required this.nominee,
    required this.bank,
  });

  factory PortfolioKycDetails.empty() {
    return PortfolioKycDetails(
      fullName: '',
      email: '',
      dob: '',
      address: '',
      panNumber: '',
      aadhaarNumber: '',
      nominee: const {},
      bank: const {},
    );
  }

  factory PortfolioKycDetails.fromJson(Map<String, dynamic> json) {
    final nominee = json['nominee'];
    final bank = json['bank'];
    return PortfolioKycDetails(
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      panNumber: json['panNumber']?.toString() ?? '',
      aadhaarNumber: json['aadhaarNumber']?.toString() ?? '',
      nominee: nominee is Map<String, dynamic> ? nominee : const {},
      bank: bank is Map<String, dynamic> ? bank : const {},
    );
  }
}

class PortfolioInvestment {
  final String? id;
  final String? propertyId;
  final String name;
  final String imageUrl;
  final String location;
  final double roi;
  final double sharePrice;
  final double propertyValue;
  final int durationYears;
  final String status;
  final String submittedAt;
  final double investedAmount;
  final int shares;
  final double currentValue;
  final double expectedReturn;
  final bool ownershipRequested;

  PortfolioInvestment({
    this.id,
    this.propertyId,
    required this.name,
    this.imageUrl = '',
    this.location = '',
    this.roi = 0,
    this.sharePrice = 0,
    this.propertyValue = 0,
    this.durationYears = 0,
    this.status = 'Investment Approved',
    this.submittedAt = '',
    required this.investedAmount,
    required this.shares,
    required this.currentValue,
    required this.expectedReturn,
    this.ownershipRequested = false,
  });

  factory PortfolioInvestment.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? property;
    final rawProperty = json['property'];
    if (rawProperty is Map<String, dynamic>) {
      property = rawProperty;
    }

    Map<String, dynamic>? nestedInvestment;
    final rawInvestment = json['investment'];
    if (rawInvestment is Map) {
      nestedInvestment = Map<String, dynamic>.from(rawInvestment);
    }

    final rawLocation = property?['location'] ?? json['location'];
    final location = rawLocation is Map
        ? [rawLocation['city'], rawLocation['state']]
              .where((value) => value != null && value.toString().trim().isNotEmpty)
              .join(', ')
        : rawLocation?.toString() ?? '';

    return PortfolioInvestment(
      id: _firstNonEmptyString([
        json['_id'],
        json['id'],
        json['investmentId'],
        json['investment_id'],
        nestedInvestment?['_id'],
        nestedInvestment?['id'],
        nestedInvestment?['investmentId'],
      ]),
      propertyId: (json['propertyId'] ?? property?['_id'] ?? property?['id'])
          ?.toString(),
      name:
          (json['propertyName'] ??
                  json['name'] ??
                  property?['name'] ??
                  'Investment')
              .toString(),
      imageUrl: (json['image'] ??
                  json['imageUrl'] ??
                  property?['image'] ??
                  property?['imageUrl'] ??
                  (property?['images'] is List &&
                          (property?['images'] as List).isNotEmpty
                      ? (property?['images'] as List).first
                      : ''))
              .toString(),
      location: location,
      roi: _toDouble(
        json['roi'] ?? json['expectedRoi'] ?? property?['roi'] ?? property?['targetROI'],
      ),
      sharePrice: _toDouble(
        json['sharePrice'] ?? property?['sharePrice'] ?? property?['pricePerShare'],
      ),
      propertyValue: _toDouble(
        json['propertyValue'] ??
            json['totalValue'] ??
            property?['totalValue'] ??
            property?['totalAssetValue'],
      ),
      durationYears: _toInt(
        json['durationYears'] ??
            json['lockInYears'] ??
            json['duration'] ??
            property?['duration'],
      ),
        status: (json['status'] ?? json['paymentStatus'] ?? 'Investment Approved')
          .toString(),
      submittedAt: (json['submittedAt'] ??
              json['createdAt'] ??
              json['created_at'] ??
              '')
          .toString(),
      investedAmount: _toDouble(
        json['investedAmount'] ??
            json['invested'] ??
            json['amount'] ??
            json['totalInvested'],
      ),
      shares: _toInt(json['shares'] ?? json['sharesOwned']),
      currentValue: _toDouble(json['currentValue']),
      expectedReturn: _toDouble(json['expectedReturn']),
      ownershipRequested: _ownershipRequested(json),
    );
  }

  String get formattedInvestedAmount => _formatInr(investedAmount);

  static String? _firstNonEmptyString(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  static bool _ownershipRequested(Map<String, dynamic> json) {
    final enableFullOwnership = json['enableFullOwnership'];
    if (enableFullOwnership == true ||
        enableFullOwnership?.toString().trim().toLowerCase() == 'true' ||
        enableFullOwnership?.toString() == '1') {
      return true;
    }

    final request = json['ownershipRequest'] ?? json['fullOwnershipRequest'];
    final requestMap = request is Map
        ? Map<String, dynamic>.from(request)
        : const <String, dynamic>{};
    final explicitValue = json['ownershipRequested'] ??
        json['fullOwnershipRequested'] ??
        json['ownershipRequestSubmitted'] ??
        requestMap['requested'] ??
        requestMap['submitted'];
    if (explicitValue is bool) return explicitValue;
    if (explicitValue != null) {
      final value = explicitValue.toString().trim().toLowerCase();
      if (value == 'true' || value == '1') return true;
    }

    final status = (json['ownershipRequestStatus'] ??
            json['fullOwnershipRequestStatus'] ??
            requestMap['status'] ??
            '')
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    return {
      'requested',
      'request_submitted',
      'pending',
      'under_review',
      'approved',
      'completed',
    }.contains(status);
  }
}

class PendingPortfolioInvestment {
  final String name;
  final String imageUrl;
  final String location;
  final int shares;
  final double amount;
  final String submittedAt;
  final String status;

  const PendingPortfolioInvestment({
    required this.name,
    this.imageUrl = '',
    this.location = '',
    required this.shares,
    required this.amount,
    this.submittedAt = '',
    this.status = 'Investment Pending',
  });

  factory PendingPortfolioInvestment.fromJson(Map<String, dynamic> json) {
    final property = json['property'] is Map
        ? Map<String, dynamic>.from(json['property'] as Map)
        : <String, dynamic>{};
    final rawLocation = property['location'] ?? json['location'];
    final location = rawLocation is Map
        ? [rawLocation['city'], rawLocation['state']]
              .where((value) => value != null && value.toString().trim().isNotEmpty)
              .join(', ')
        : [rawLocation, json['state']]
              .where((value) => value != null && value.toString().trim().isNotEmpty)
              .join(', ');
    final images = property['images'];

    return PendingPortfolioInvestment(
      name: (json['propertyName'] ??
              json['name'] ??
              property['name'] ??
              'Investment')
          .toString(),
      imageUrl: (json['image'] ??
              json['imageUrl'] ??
              property['image'] ??
              property['imageUrl'] ??
              (images is List && images.isNotEmpty ? images.first : ''))
          .toString(),
      location: location,
      shares: _toInt(json['shares'] ?? json['sharesOwned']),
      amount: _toDouble(
        json['amount'] ??
            json['invested'] ??
            json['investedAmount'] ??
            json['totalInvested'],
      ),
      submittedAt: (json['submittedAt'] ??
              json['createdAt'] ??
              json['created_at'] ??
              '')
          .toString(),
      status: (json['paymentStatus'] ?? json['status'] ?? 'Investment Pending')
          .toString(),
    );
  }

  String get formattedAmount => _formatInr(amount);

  String get displayStatus {
    final normalized = status.trim().toLowerCase().replaceAll('-', '_');
    switch (normalized) {
      case 'not_paid':
      case 'notpaid':
        return 'Not Paid';
      case 'paid':
      case 'payment_done':
      case 'payment_submitted':
        return 'Paid';
      case 'verified':
        return 'Payment Verified';
      case 'investment_approved':
      case 'approved':
        return 'Investment Approved';
      case 'payment_under_review':
      case 'under_review':
        return 'Payment Under Review';
      default:
        return status.trim().isEmpty ? 'Investment Pending' : status;
    }
  }
}

class PortfolioModel {
  final PortfolioSummary summary;
  final List<PortfolioInvestment> investments;
  final List<PendingPortfolioInvestment> pendingInvestments;
  final List<PendingPortfolioInvestment> paymentHistory;
  final List<PortfolioDocument> documents;
  final PortfolioKycDetails kycDetails;

  PortfolioModel({
    required this.summary,
    required this.investments,
    required this.pendingInvestments,
    required this.paymentHistory,
    required this.documents,
    required this.kycDetails,
  });

  factory PortfolioModel.empty() {
    return PortfolioModel(
      summary: PortfolioSummary.empty(),
      investments: const [],
      pendingInvestments: const [],
      paymentHistory: const [],
      documents: const [],
      kycDetails: PortfolioKycDetails.empty(),
    );
  }

  factory PortfolioModel.fromJson(dynamic json) {
    Map<String, dynamic>? map;
    if (json is Map<String, dynamic>) {
      map = json;
      final nested = json['data'];
      if (nested is Map<String, dynamic>) {
        map = nested;
      }
    }
    if (map == null) return PortfolioModel.empty();

    final summaryJson = map['summary'];
    final summary = summaryJson is Map<String, dynamic>
        ? PortfolioSummary.fromJson(summaryJson)
        : PortfolioSummary.empty();

    final investmentsJson = map['investments'];
    final investments = <PortfolioInvestment>[];
    if (investmentsJson is List) {
      for (final item in investmentsJson) {
        if (item is Map<String, dynamic>) {
          investments.add(PortfolioInvestment.fromJson(item));
        }
      }
    }

    final pendingInvestments = <PendingPortfolioInvestment>[];
    final pendingJson = map['pendingInvestments'] ??
        map['pending'] ??
        map['pendingRequests'];
    if (pendingJson is List) {
      for (final item in pendingJson) {
        if (item is Map) {
          pendingInvestments.add(
            PendingPortfolioInvestment.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    final paymentHistory = <PendingPortfolioInvestment>[];
    final paymentJson = map['paymentHistory'] ??
        map['transactions'] ??
        map['payments'];
    if (paymentJson is List) {
      for (final item in paymentJson) {
        if (item is Map) {
          paymentHistory.add(
            PendingPortfolioInvestment.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    final documents = <PortfolioDocument>[];
    final documentsJson = map['documents'];
    if (documentsJson is List) {
      for (final item in documentsJson) {
        if (item is Map<String, dynamic>) {
          documents.add(PortfolioDocument.fromJson(item));
        }
      }
    }

    final kycJson = map['kycDetails'];
    final kycDetails = kycJson is Map<String, dynamic>
        ? PortfolioKycDetails.fromJson(kycJson)
        : PortfolioKycDetails.empty();

    return PortfolioModel(
      summary: summary,
      investments: investments,
      pendingInvestments: pendingInvestments,
      paymentHistory: paymentHistory,
      documents: documents,
      kycDetails: kycDetails,
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.round();
  return int.tryParse(value.toString()) ?? 0;
}

String _formatInr(num val) {
  if (val >= 10000000) {
    return '₹${(val / 10000000).toStringAsFixed(1)}Cr';
  }
  if (val >= 100000) {
    return '₹${(val / 100000).toStringAsFixed(1)}L';
  }
  final rounded = val.round();
  final formatted = rounded.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return '₹$formatted';
}
