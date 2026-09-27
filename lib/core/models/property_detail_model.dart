class PropertyDetailLocation {
  final String? city;
  final String? state;
  final String? address;
  final String? street;
  final String? landmark;
  final String? pincode;
  final double? lat;
  final double? lng;

  PropertyDetailLocation({
    this.city,
    this.state,
    this.address,
    this.street,
    this.landmark,
    this.pincode,
    this.lat,
    this.lng,
  });

  factory PropertyDetailLocation.fromJson(Map<String, dynamic> json) {
    return PropertyDetailLocation(
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      street: json['street']?.toString(),
      landmark: json['landmark']?.toString(),
      pincode: json['pincode']?.toString(),
      lat: PropertyDetailModel._toDouble(json['lat']),
      lng: PropertyDetailModel._toDouble(json['lng']),
    );
  }
}

class PropertyDetailCalculator {
  final int? pricePerShare;
  final double? roi;

  PropertyDetailCalculator({this.pricePerShare, this.roi});

  factory PropertyDetailCalculator.fromJson(Map<String, dynamic> json) {
    return PropertyDetailCalculator(
      pricePerShare: PropertyDetailModel._toInt(
        json['pricePerShare'] ?? json['sharePrice'],
      ),
      roi: PropertyDetailModel._toDouble(json['roi']),
    );
  }
}

class PropertyDetailDocument {
  final String? name;
  final String? url;
  final String? id;

  PropertyDetailDocument({this.name, this.url, this.id});

  factory PropertyDetailDocument.fromJson(Map<String, dynamic> json) {
    return PropertyDetailDocument(
      name: json['name']?.toString(),
      url: json['url']?.toString(),
      id: (json['_id'] ?? json['id'])?.toString(),
    );
  }
}

class PropertyDetailModel {
  final String? id;
  final String name;
  final String? type;
  final List<String> images;
  final String? video;
  final String? brochure;
  final PropertyDetailLocation? location;

  final int? totalValue;
  final int? totalShares;
  final int? sharePrice;
  final int? buyingCycle;
  final int? minimumShares;

  final double? roi;
  final double? targetROI;
  final double? fundedPercent;

  final int? sharesLeft;
  final int? investors;

  final double? rentalYield;
  final double? appreciation;

  final int? duration;

  final String? description;
  final String? size;

  final List<String> highlights;
  final List<String> amenities;

  final List<PropertyDetailDocument> documents;

  final String? tenants;
  final String? propertyGrade;

  final PropertyDetailCalculator? calculator;

  PropertyDetailModel({
    this.id,
    required this.name,
    this.type,
    required this.images,
    this.video,
    this.brochure,
    this.location,
    this.totalValue,
    this.totalShares,
    this.sharePrice,
    this.buyingCycle,
    this.minimumShares,
    this.roi,
    this.targetROI,
    this.fundedPercent,
    this.sharesLeft,
    this.investors,
    this.rentalYield,
    this.appreciation,
    this.duration,
    this.description,
    this.size,
    required this.highlights,
    required this.amenities,
    required this.documents,
    this.tenants,
    this.propertyGrade,
    this.calculator,
  });

  // ------------------------------------------------------------
  // JSON HELPERS
  // ------------------------------------------------------------

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.toInt();
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? double.tryParse(value)?.toInt();
    }

    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }

    return null;
  }

  static String? _toString(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty) return null;

    return result;
  }

  static String _requiredString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'] is Map
        ? Map<String, dynamic>.from(json['media'] as Map)
        : <String, dynamic>{};

    // Images can be at root or nested under media.
    final List<String> imageList = [];
    final imagesSource = json['images'] is List ? json['images'] : media['images'];
    if (imagesSource is List) {
      imageList.addAll(
        imagesSource
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty),
      );
    }

    // Highlights
    final List<String> highlightList = [];

    if (json['highlights'] is List) {
      highlightList.addAll(
        (json['highlights'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty),
      );
    }

    // Amenities
    final List<String> amenityList = [];

    if (json['amenities'] is List) {
      amenityList.addAll(
        (json['amenities'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty),
      );
    }

    // Documents can be at root or nested under media.
    final List<PropertyDetailDocument> documentList = [];
    final documentsSource =
        json['documents'] is List ? json['documents'] : media['documents'];
    if (documentsSource is List) {
      for (final item in documentsSource) {
        if (item is Map) {
          documentList.add(
            PropertyDetailDocument.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    // Location
    PropertyDetailLocation? propertyLocation;

    if (json['location'] is Map) {
      propertyLocation = PropertyDetailLocation.fromJson(
        Map<String, dynamic>.from(json['location']),
      );
    }

    // Calculator
    PropertyDetailCalculator? propertyCalculator;

    if (json['calculator'] is Map) {
      propertyCalculator = PropertyDetailCalculator.fromJson(
        Map<String, dynamic>.from(json['calculator']),
      );
    }

    return PropertyDetailModel(
      id: _toString(json['id'] ?? json['_id']),

      name: _requiredString(json['name']),

      type: _toString(json['type']),

      images: imageList,

      video: _toString(json['video'] ?? media['video']),

      brochure: _toString(json['brochure'] ?? media['brochure']),

      location: propertyLocation,

      // Integers
      totalValue: _toInt(json['totalValue']),

      totalShares: _toInt(
        json['totalShares'] ?? json['sharesAvailable'] ?? json['availableShares'],
      ),

      sharePrice: _toInt(
        json['sharePrice'] ?? json['pricePerShare'] ?? json['pricePerUnit'],
      ),

      buyingCycle: _toInt(
        json['buyingCycle'] ?? json['buying_cycle'] ?? json['cycle'] ?? json['shareCycle'],
      ),

      minimumShares: _toInt(
        json['minimumShares'] ?? json['minShares'] ?? json['minimumShare'] ?? json['shareMultiple'],
      ),

      // Doubles
      roi: _toDouble(json['roi']),

      targetROI: _toDouble(json['targetROI']),

      fundedPercent: _toDouble(
        json['fundedPercent'] ?? json['soldPercent'],
      ),

      // Integers
      sharesLeft: _toInt(
        json['sharesLeft'] ?? json['availableShares'],
      ),

      investors: _toInt(json['investors']),

      // Doubles
      rentalYield: _toDouble(json['rentalYield']),

      appreciation: _toDouble(json['appreciation']),

      duration: _toInt(json['duration']),

      description: _toString(json['description']),

      size: _toString(json['size']),

      highlights: highlightList,

      amenities: amenityList,

      documents: documentList,

      tenants: _toString(json['tenants']),

      propertyGrade: _toString(json['propertyGrade']),

      calculator: propertyCalculator,
    );
  }

  // ------------------------------------------------------------
  // DISPLAY LOCATION
  // ------------------------------------------------------------

  String get displayLocation {
    if (location == null) return '';

    final parts = <String>[];

    if (location!.address?.trim().isNotEmpty == true) {
      parts.add(location!.address!.trim());
    }

    if (location!.city?.trim().isNotEmpty == true) {
      parts.add(location!.city!.trim());
    }

    if (location!.state?.trim().isNotEmpty == true) {
      parts.add(location!.state!.trim());
    }

    return parts.join(', ');
  }

  // ------------------------------------------------------------
  // FIRST IMAGE
  // ------------------------------------------------------------

  String get firstImage {
    if (images.isEmpty) return '';

    return images.first;
  }

  // ------------------------------------------------------------
  // TYPE LABEL
  // ------------------------------------------------------------

  String get typeLabel {
    final t = (type ?? '').trim().toLowerCase();

    if (t.isEmpty || t == 'undefined') {
      return 'COMMERCIAL REAL ESTATE';
    }

    if (t.contains('residential')) {
      return 'RESIDENTIAL PROPERTY';
    }

    if (t.contains('commercial')) {
      return 'COMMERCIAL REAL ESTATE';
    }

    return t.toUpperCase();
  }

  // ------------------------------------------------------------
  // TYPE DISPLAY
  // ------------------------------------------------------------

  String get typeDisplay {
    final t = (type ?? '').trim();

    if (t.isEmpty || t.toLowerCase() == 'undefined') {
      return 'Commercial';
    }

    return t[0].toUpperCase() + t.substring(1);
  }

  // ------------------------------------------------------------
  // SHARE PRICE
  // ------------------------------------------------------------

  String get formattedSharePrice {
    final value = calculator?.pricePerShare ?? sharePrice ?? 0;

    return _formatINR(value);
  }

  // ------------------------------------------------------------
  // TOTAL VALUE
  // ------------------------------------------------------------

  int get effectiveBuyingCycle {
    final value = buyingCycle ?? 5;
    return value > 0 ? value : 5;
  }

  int get effectiveMinimumShares {
    final value = minimumShares ?? (effectiveBuyingCycle * 2);
    return value > 0 ? value : effectiveBuyingCycle * 2;
  }

  int get effectiveShareLimit {
    final value = sharesLeft ?? totalShares ?? 1000;
    return value > 0 ? value : 1000;
  }

  String get formattedTotalValue {
    return _formatINR(totalValue ?? 0);
  }

  // ------------------------------------------------------------
  // ROI
  // ------------------------------------------------------------

  String get formattedRoi {
    final value = calculator?.roi ?? roi ?? 0.0;

    return '${value.toStringAsFixed(1)}%';
  }

  // ------------------------------------------------------------
  // TARGET ROI
  // ------------------------------------------------------------

  String get formattedTargetRoi {
    final value = targetROI ?? 0.0;

    return '${value.toStringAsFixed(1)}%';
  }

  // ------------------------------------------------------------
  // RENTAL YIELD
  // ------------------------------------------------------------

  String get formattedYield {
    final value = rentalYield ?? 0.0;

    return '${value.toStringAsFixed(1)}%';
  }

  // ------------------------------------------------------------
  // FUNDED PERCENT
  // ------------------------------------------------------------

  int get displayFundedPercent {
    final value = (fundedPercent ?? 0.0).clamp(0.0, 100.0);

    return value.round();
  }

  // ------------------------------------------------------------
  // FUNDED AMOUNT
  // ------------------------------------------------------------

  String get fundedAmount {
    final percent =
        (fundedPercent ?? 0.0).clamp(0.0, 100.0) / 100;

    final amount =
    ((totalValue ?? 0) * percent).toInt();

    return _formatINR(amount);
  }

  // ------------------------------------------------------------
  // INR FORMATTER
  // ------------------------------------------------------------

  static String _formatINR(int value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    }

    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    }

    if (value >= 1000) {
      return '₹${value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]},',
      )}';
    }

    return '₹$value';
  }
}