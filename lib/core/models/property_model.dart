class PropertyLocation {
  final String? city;
  final String? state;
  final String? address;
  final String? street;
  final String? landmark;
  final String? pincode;
  final double? lat;
  final double? lng;

  PropertyLocation({
    this.city,
    this.state,
    this.address,
    this.street,
    this.landmark,
    this.pincode,
    this.lat,
    this.lng,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      street: json['street']?.toString(),
      landmark: json['landmark']?.toString(),
      pincode: json['pincode']?.toString(),
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );
  }

  Map<String, dynamic> toJson() => {
        'city': city,
        'state': state,
        'address': address,
        'street': street,
        'landmark': landmark,
        'pincode': pincode,
        'lat': lat,
        'lng': lng,
      };
}

class PropertyDocument {
  final String? name;
  final String? url;
  final String? id;

  PropertyDocument({this.name, this.url, this.id});

  factory PropertyDocument.fromJson(Map<String, dynamic> json) {
    return PropertyDocument(
      name: json['name']?.toString(),
      url: json['url']?.toString(),
      id: json['_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
        '_id': id,
      };
}

class PropertyMedia {
  final List<String> images;
  final String? video;
  final String? brochure;
  final List<PropertyDocument> documents;

  PropertyMedia({
    required this.images,
    this.video,
    this.brochure,
    required this.documents,
  });

  factory PropertyMedia.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] != null && json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    List<PropertyDocument> docList = [];
    if (json['documents'] != null && json['documents'] is List) {
      docList = (json['documents'] as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => PropertyDocument.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PropertyMedia(
      images: imgList,
      video: (json['video']?.toString() ?? '').trim().isEmpty
          ? null
          : (json['video']?.toString() ?? '').trim(),
      brochure: (json['brochure']?.toString() ?? '').trim().isEmpty
          ? null
          : (json['brochure']?.toString() ?? '').trim(),
      documents: docList,
    );
  }

  Map<String, dynamic> toJson() => {
        'images': images,
        'video': video,
        'brochure': brochure,
        'documents': documents.map((e) => e.toJson()).toList(),
      };
}

class PropertyModel {
  final String? id;
  final String name;
  final String? type;
  final String? category;
  final String? description;
  final String? size;
  final int totalValue;
  final int totalShares;
  final int soldShares;
  final int? availableShares;
  final int pricePerShare;
  final int? currentPricePerShare;
  final double roi;
  final double targetROI;
  final double rentalYield;
  final double appreciation;
  final int duration;
  final double soldPercent;
  final int investors;
  final int investedAmount;
  final bool isPublished;
  final bool isFeatured;
  final String? tenants;
  final String? propertyGrade;
  final String? status;
  final List<String> highlights;
  final List<String> amenities;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PropertyLocation? location;
  final PropertyMedia? media;

  PropertyModel({
    this.id,
    required this.name,
    this.type,
    this.category,
    this.description,
    this.size,
    required this.totalValue,
    required this.totalShares,
    required this.soldShares,
    this.availableShares,
    required this.pricePerShare,
    this.currentPricePerShare,
    required this.roi,
    required this.targetROI,
    required this.rentalYield,
    required this.appreciation,
    required this.duration,
    required this.soldPercent,
    required this.investors,
    required this.investedAmount,
    required this.isPublished,
    required this.isFeatured,
    this.tenants,
    this.propertyGrade,
    this.status,
    required this.highlights,
    required this.amenities,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.media,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    List<String> hlList = [];
    if (json['highlights'] != null && json['highlights'] is List) {
      hlList =
          (json['highlights'] as List).map((e) => e.toString()).toList();
    }

    List<String> amList = [];
    if (json['amenities'] != null && json['amenities'] is List) {
      amList = (json['amenities'] as List).map((e) => e.toString()).toList();
    }

    return PropertyModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString(),
      category: json['category']?.toString(),
      description: json['description']?.toString(),
      size: json['size']?.toString(),
      totalValue: (json['totalValue'] as num?)?.toInt() ?? 0,
      totalShares: (json['totalShares'] as num?)?.toInt() ?? 0,
      soldShares: (json['soldShares'] as num?)?.toInt() ?? 0,
      availableShares: (json['availableShares'] as num?)?.toInt(),
      pricePerShare: (json['pricePerShare'] as num?)?.toInt() ?? 0,
      currentPricePerShare: (json['currentPricePerShare'] as num?)?.toInt(),
      roi: (json['roi'] as num?)?.toDouble() ?? 0.0,
      targetROI: (json['targetROI'] as num?)?.toDouble() ?? 0.0,
      rentalYield: (json['rentalYield'] as num?)?.toDouble() ?? 0.0,
      appreciation: (json['appreciation'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      soldPercent: (json['soldPercent'] as num?)?.toDouble() ?? 0.0,
      investors: (json['investors'] as num?)?.toInt() ?? 0,
      investedAmount: (json['investedAmount'] as num?)?.toInt() ?? 0,
      isPublished: json['isPublished'] == true,
      isFeatured: json['isFeatured'] == true,
      tenants: json['tenants']?.toString(),
      propertyGrade: json['propertyGrade']?.toString(),
      status: json['status']?.toString(),
      highlights: hlList,
      amenities: amList,
      createdBy: json['createdBy']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      location: json['location'] != null && json['location'] is Map<String, dynamic>
          ? PropertyLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null && json['media'] is Map<String, dynamic>
          ? PropertyMedia.fromJson(json['media'] as Map<String, dynamic>)
          : null,
    );
  }

  static List<PropertyModel> listFromJson(dynamic json) {
    if (json == null) return [];
    dynamic payload = json;
    if (json is Map) {
      payload = json['data'] ??
          json['properties'] ??
          json['result'] ??
          json['items'];
      if (payload is Map) {
        payload = payload['properties'] ?? payload['data'] ?? payload['items'];
      }
    }
    if (payload is! List) return [];
    return payload
        .where((e) => e is Map<String, dynamic>)
        .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'type': type,
        'category': category,
        'description': description,
        'size': size,
        'totalValue': totalValue,
        'totalShares': totalShares,
        'soldShares': soldShares,
        'availableShares': availableShares,
        'pricePerShare': pricePerShare,
        'currentPricePerShare': currentPricePerShare,
        'roi': roi,
        'targetROI': targetROI,
        'rentalYield': rentalYield,
        'appreciation': appreciation,
        'duration': duration,
        'soldPercent': soldPercent,
        'investors': investors,
        'investedAmount': investedAmount,
        'isPublished': isPublished,
        'isFeatured': isFeatured,
        'tenants': tenants,
        'propertyGrade': propertyGrade,
        'status': status,
        'highlights': highlights,
        'amenities': amenities,
        'createdBy': createdBy,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'location': location?.toJson(),
        'media': media?.toJson(),
      };

  String get displayLocation {
    if (location == null) return '';
    final parts = <String>[];
    if (location!.city != null && location!.city!.isNotEmpty) {
      parts.add(location!.city!);
    }
    if (location!.state != null && location!.state!.isNotEmpty) {
      parts.add(location!.state!);
    }
    return parts.join(', ');
  }

  String get firstImage {
    if (media == null || media!.images.isEmpty) return '';
    return media!.images.first;
  }

  String get typeDisplay {
    if (category != null && category!.isNotEmpty && category != 'undefined') {
      return category!;
    }
    if (type != null && type!.isNotEmpty && type != 'undefined') {
      return type![0].toUpperCase() + type!.substring(1);
    }
    return 'Commercial';
  }

  int get displaySoldPercent {
    final p = soldPercent.clamp(0.0, 100.0);
    return p.round();
  }

  String get formattedRoi => '${roi.toStringAsFixed(1)}%';

  String get formattedYield => '${rentalYield.toStringAsFixed(1)}%';

  String get formattedPricePerShare {
    final val = pricePerShare;
    if (val >= 10000000) {
      return '₹${(val / 10000000).toStringAsFixed(1)}Cr';
    } else if (val >= 100000) {
      return '₹${(val / 100000).toStringAsFixed(1)}L';
    }
    return '₹${val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  String get formattedTotalValue {
    final val = totalValue;
    if (val >= 10000000) {
      return '₹${(val / 10000000).toStringAsFixed(1)}Cr';
    } else if (val >= 100000) {
      return '₹${(val / 100000).toStringAsFixed(1)}L';
    }
    return '₹$val';
  }
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}
