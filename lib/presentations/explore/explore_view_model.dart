import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/helper/routing_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/property_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../property_detail/property_detail_view.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';

enum YieldSort { highest, lowest }

class ExploreViewModel extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  final AppRepository _repo = injector<AppRepository>();

  final List<String> assetFilters = const [
    'All Assets',
    'Commercial',
    'Residential',
  ];

  int _selectedAssetFilter = 0;
  int get selectedAssetFilter => _selectedAssetFilter;

  YieldSort _yieldSort = YieldSort.highest;
  YieldSort get yieldSort => _yieldSort;

  String get yieldSortLabel => _yieldSort == YieldSort.highest
      ? 'Sort By: Highest Yield'
      : 'Sort By: Lowest Yield';

  final Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;
  final Set<String> _pendingFavoriteIds = {};

  List<PropertyModel> _allProperties = [];
  List<PropertyModel> _filteredProperties = [];
  List<PropertyModel> get properties => _filteredProperties;

  PropertyModel? get featuredProperty =>
      _filteredProperties.isNotEmpty ? _filteredProperties.first : null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<String> locationOptions = [];
  bool isLoadingLocations = false;
  final Set<String> selectedCities = {};
  String selectedPropertyType = '';
  double? selectedMaxPrice;
  String selectedFundingStatus = 'All';
  bool isApplyingFilters = false;

  static const double budgetMin = 100000;
  static const double budgetMax = 100000000;

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
        return t.contains('commercial') ||
            c.contains('office') ||
            c.contains('commercial');
      }).toList();
    } else if (_selectedAssetFilter == 2) {
      result = result.where((p) {
        final t = (p.type ?? '').toLowerCase();
        final c = (p.category ?? '').toLowerCase();
        return t.contains('residential') || c.contains('residential');
      }).toList();
    }

    final q = searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((p) => p.name.toLowerCase().contains(q)).toList();
    }

    result.sort((a, b) {
      final cmp = a.rentalYield.compareTo(b.rentalYield);
      return _yieldSort == YieldSort.highest ? -cmp : cmp;
    });

    _filteredProperties = result;
  }

  void setAssetFilter(int index) {
    _selectedAssetFilter = index;
    _applyFilters();
    notifyListeners();
  }

  void setYieldSort(YieldSort sort) {
    _yieldSort = sort;
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    if (id.isEmpty || _pendingFavoriteIds.contains(id)) return;

    _pendingFavoriteIds.add(id);
    notifyListeners();

    try {
      final result = await _repo.watchlistToggle(id);
      if (result is DataSuccess) {
        final wasSaved = _favoriteIds.contains(id);
        if (wasSaved) {
          _favoriteIds.remove(id);
        } else {
          _favoriteIds.add(id);
        }
        AppSnackBar.show(
          message: wasSaved
              ? 'Removed from saved properties'
              : 'Property saved',
        );
      } else if (result is DataFailed) {
        _errorMessage = result.error ?? 'Failed to update watchlist';
        AppSnackBar.show(message: _errorMessage!, isError: true);
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      AppSnackBar.show(message: _errorMessage!, isError: true);
    } finally {
      _pendingFavoriteIds.remove(id);
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _applyFilters();
    notifyListeners();
  }

  void onSearchSubmitted(String value) {
    _applyFilters();
    notifyListeners();
  }

  Future<void> ensureLocations() async {
    if (locationOptions.isNotEmpty || isLoadingLocations) return;
    isLoadingLocations = true;
    notifyListeners();
    try {
      var source = _allProperties;
      if (source.isEmpty) {
        final result = await _repo.properties();
        if (result is DataSuccess) {
          source = PropertyModel.listFromJson(result.data);
        }
      }
      final cities = source
          .map((property) => (property.location?.city ?? '').trim().toLowerCase())
          .where((city) => city.isNotEmpty)
          .toSet()
          .toList()
        ..sort();
      locationOptions
        ..clear()
        ..addAll(cities);
    } finally {
      isLoadingLocations = false;
      notifyListeners();
    }
  }

  Future<bool> applyExploreFilters({
    required Set<String> cities,
    required String type,
    required double? maxPrice,
    required String fundingStatus,
  }) async {
    selectedCities
      ..clear()
      ..addAll(cities);
    selectedPropertyType = type;
    selectedMaxPrice = maxPrice;
    selectedFundingStatus = fundingStatus;
    _selectedAssetFilter = switch (type) {
      'commercial' => 1,
      'residential' => 2,
      _ => 0,
    };

    isApplyingFilters = true;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.exploreProperties(
        search: searchController.text.trim(),
        city: cities.isEmpty ? null : (cities.toList()..sort()).join(','),
        type: type.isEmpty ? null : type,
        maxPrice: maxPrice?.round(),
        status: fundingStatus == 'In Progress' ? 'funding' : null,
      );
      if (result is DataSuccess) {
        _allProperties = PropertyModel.listFromJson(result.data);
        _applyFilters();
        return true;
      }
      _errorMessage = result is DataFailed
          ? (result.error ?? 'Failed to apply filters')
          : 'Failed to apply filters';
      AppSnackBar.show(message: _errorMessage!, isError: true);
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      AppSnackBar.show(message: _errorMessage!, isError: true);
      return false;
    } finally {
      isApplyingFilters = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetExploreFilters() async {
    selectedCities.clear();
    selectedPropertyType = '';
    selectedMaxPrice = null;
    selectedFundingStatus = 'All';
    _selectedAssetFilter = 0;
    await fetchProperties();
  }

  void onFilterPressed() {}

  void onMapViewPressed() {}

  void onPropertyTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onInvestNowTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onQuickInvestTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onViewDetailsTap(String propertyId) {
    _openDetail(propertyId);
  }

  void retry() {
    fetchProperties();
  }

  void _openDetail(String propertyId) {
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
