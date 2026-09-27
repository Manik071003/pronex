import 'package:pronex/core/constants/constant_imports.dart';
import 'package:pronex/core/helper/helper_imports.dart';
import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/helper/routing_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/property_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../explore/explore_view.dart';
import '../property_detail/property_detail_view.dart';

class HomeViewModel extends BaseViewModel {
  static const int maxHomeProperties = 8;

  final TextEditingController searchController = TextEditingController();
  final AppRepository _repo = injector<AppRepository>();

  final List<String> assetFilters = const [
    'All Assets',
    'Residential',
    'Commercial',
  ];

  int _selectedAssetFilter = 0;
  int get selectedAssetFilter => _selectedAssetFilter;

  final Map<int, bool> _faqExpanded = {};
  Map<int, bool> get faqExpanded => _faqExpanded;

  List<PropertyModel> _allProperties = [];
  List<PropertyModel> _displayProperties = [];
  List<PropertyModel> get displayProperties => _displayProperties;

  bool get isSearching => searchController.text.trim().isNotEmpty;

  PropertyModel? get featuredProperty =>
      _displayProperties.isNotEmpty ? _displayProperties.first : null;

  List<PropertyModel> get opportunityProperties {
    if (_displayProperties.length <= 1) return const [];
    return _displayProperties.sublist(1);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
String? name;
  Future<void> init() async {
    name=await SharedPrefHelper.getString(SharedPrefs.userName);
    notifyListeners();
    await fetchProperties();
  }

  Future<void> fetchProperties() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.properties();
      if (result is DataSuccess) {
        _allProperties = PropertyModel.listFromJson(result.data);
        _applyFilters();
      } else if (result is DataFailed) {
        _errorMessage = result.error ?? 'Failed to load properties';
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    List<PropertyModel> result = List.from(_allProperties);

    if (_selectedAssetFilter == 1) {
      result = result.where((p) {
        final t = (p.type ?? '').toLowerCase();
        final c = (p.category ?? '').toLowerCase();
        return t.contains('residential') || c.contains('residential');
      }).toList();
    } else if (_selectedAssetFilter == 2) {
      result = result.where((p) {
        final t = (p.type ?? '').toLowerCase();
        final c = (p.category ?? '').toLowerCase();
        return t.contains('commercial') ||
            c.contains('office') ||
            c.contains('commercial');
      }).toList();
    }

    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((property) {
        final location = property.location;
        final haystack = [
          property.name,
          property.displayLocation,
          property.typeDisplay,
          property.type,
          property.category,
          property.description,
          location?.city,
          location?.state,
          location?.address,
        ].whereType<String>().join(' ').toLowerCase();
        return haystack.contains(query);
      }).toList();
    } else if (result.length > maxHomeProperties) {
      result = result.take(maxHomeProperties).toList();
    }

    _displayProperties = result;
  }

  void setAssetFilter(int index) {
    _selectedAssetFilter = index;
    _applyFilters();
    notifyListeners();
  }

  void toggleFaq(int index) {
    _faqExpanded[index] = !(_faqExpanded[index] ?? false);
    notifyListeners();
  }

  void onSearchChanged(String value) {
    _applyFilters();
    notifyListeners();
  }

  void onSearchSubmitted(String value) {
    onSearchChanged(value);
  }

  void onNotificationPressed() {}

  void onProfilePressed() {}

  void onPropertyTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onInvestNowTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onViewAllOpportunities() {
    RoutingHelper.pushToScreen(screen: const ExploreView());
  }

  void onRecommendedTap(String propertyId) {
    _openDetail(propertyId);
  }

  void retry() {
    fetchProperties();
  }

  void _openDetail(String propertyId) {
    if (propertyId.isEmpty) return;
    RoutingHelper.pushToScreen(
      screen: PropertyDetailView(propertyId: propertyId),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
