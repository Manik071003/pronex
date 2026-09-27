import 'package:flutter/material.dart';
import '../../core/di/injector.dart';
import '../../core/helper/investment_payment_flow.dart';
import '../../core/helper/routing_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/property_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../property_detail/property_detail_view.dart';
import '../widgets/custom_widgets/custom_snackbar.dart';

enum SavedYieldSort { highest, lowest }

class SavedViewModel extends BaseViewModel {
  final TextEditingController searchController = TextEditingController();
  final AppRepository _repo = injector<AppRepository>();

  final List<String> assetFilters = const [
    'All Assets',
    'Commercial',
    'Residential',
  ];

  int _selectedAssetFilter = 0;
  int get selectedAssetFilter => _selectedAssetFilter;

  final Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  List<PropertyModel> _allProperties = [];
  List<PropertyModel> _filteredProperties = [];
  List<PropertyModel> get properties => _filteredProperties;

  SavedYieldSort _yieldSort = SavedYieldSort.highest;
  SavedYieldSort get yieldSort => _yieldSort;
  String get yieldSortLabel => _yieldSort == SavedYieldSort.highest
      ? 'Sort By: Highest Yield'
      : 'Sort By: Lowest Yield';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWatchlist() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.watchlist();
      if (result is DataSuccess) {
        _allProperties = PropertyModel.listFromJson(result.data);
        _favoriteIds
          ..clear()
          ..addAll(
            _allProperties.map((property) => property.id).whereType<String>(),
          );
        _applyFilters();
      } else if (result is DataFailed) {
        _errorMessage = result.error ?? 'Failed to load saved properties';
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    var result = List<PropertyModel>.from(_allProperties);

    if (_selectedAssetFilter == 1) {
      result = result.where((property) {
        final type = (property.type ?? '').toLowerCase();
        final category = (property.category ?? '').toLowerCase();
        return type.contains('commercial') ||
            category.contains('office') ||
            category.contains('commercial');
      }).toList();
    } else if (_selectedAssetFilter == 2) {
      result = result.where((property) {
        final type = (property.type ?? '').toLowerCase();
        final category = (property.category ?? '').toLowerCase();
        return type.contains('residential') || category.contains('residential');
      }).toList();
    }

    final query = searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where((property) => property.name.toLowerCase().contains(query))
          .toList();
    }

    result.sort((a, b) {
      final comparison = a.rentalYield.compareTo(b.rentalYield);
      return _yieldSort == SavedYieldSort.highest ? -comparison : comparison;
    });
    _filteredProperties = result;
  }

  void setAssetFilter(int index) {
    _selectedAssetFilter = index;
    _applyFilters();
    notifyListeners();
  }

  void setYieldSort(SavedYieldSort sort) {
    _yieldSort = sort;
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final result = await _repo.watchlistToggle(id);
    if (result is DataSuccess) {
      AppSnackBar.show(message: 'Removed from saved properties');
      await fetchWatchlist();
    } else if (result is DataFailed) {
      _errorMessage = result.error ?? 'Failed to update watchlist';
      AppSnackBar.show(message: _errorMessage!, isError: true);
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

  void onFilterPressed() {}

  void onSortPressed() {
    setYieldSort(
      _yieldSort == SavedYieldSort.highest
          ? SavedYieldSort.lowest
          : SavedYieldSort.highest,
    );
  }

  void onMapViewPressed() {}

  void onPropertyTap(String propertyId) {
    _openDetail(propertyId);
  }

  void onInvestNowTap(String propertyId) {
    onQuickInvestTap(propertyId);
  }

  void onQuickInvestTap(String propertyId) {
    if (propertyId.isEmpty) return;
    InvestmentPaymentFlow.onProceedToPayment(
      propertyId: propertyId,
      shares: 1,
    );
  }

  void onViewDetailsTap(String propertyId) {
    _openDetail(propertyId);
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
