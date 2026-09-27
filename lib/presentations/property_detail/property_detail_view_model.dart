import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/di/injector.dart';
import '../../core/helper/investment_payment_flow.dart';
import '../../core/helper/routing_helper.dart';
import '../../core/models/base_view_model.dart';
import '../../core/models/property_detail_model.dart';
import '../../core/models/property_model.dart';
import '../../core/repository/app_repository.dart';
import '../../core/utils/data_state.dart';
import '../property_video_player/property_video_player_view.dart';

class PropertyDetailViewModel extends BaseViewModel {
  final String propertyId;
  final AppRepository _repo = injector<AppRepository>();

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  bool _isAboutExpanded = false;
  bool get isAboutExpanded => _isAboutExpanded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PropertyDetailModel? _property;
  PropertyDetailModel? get property => _property;

  List<PropertyModel> _relatedProperties = [];
  List<PropertyModel> get relatedProperties => _relatedProperties;

  bool _isLoadingRelated = false;
  bool get isLoadingRelated => _isLoadingRelated;

  PropertyDetailViewModel(this.propertyId);

  Future<void> fetchProperty() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.propertyDetail(propertyId);
      if (result is DataSuccess) {
        final data = result.data;
        if (data is Map) {
          _property = PropertyDetailModel.fromJson(
            Map<String, dynamic>.from(data),
          );
          await fetchRelatedProperties();
        } else {
          _errorMessage = 'Unexpected response format';
        }
      } else if (result is DataFailed) {
        _errorMessage = result.error ?? 'Failed to load property details';
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRelatedProperties() async {
    if (propertyId.isEmpty) return;
    _isLoadingRelated = true;
    notifyListeners();
    try {
      final result = await _repo.relatedProperties(propertyId);
      if (result is DataSuccess) {
        final payload = result.data;
        if (payload is Map && payload['data'] is List) {
          _relatedProperties = payload['data']
              .map((item) => PropertyModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else if (payload is List) {
          _relatedProperties = payload
              .map((item) => PropertyModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      }
    } catch (_) {
      _relatedProperties = [];
    } finally {
      _isLoadingRelated = false;
      notifyListeners();
    }
  }

  void retry() {
    fetchProperty();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void toggleAboutExpanded() {
    _isAboutExpanded = !_isAboutExpanded;
    notifyListeners();
  }

  Future<void> onInvestNowPressed() async {
    final property = _property;
    if (property == null || propertyId.isEmpty || isBusy) return;
    setBusy(true);
    try {
      await InvestmentPaymentFlow.onProceedToPayment(
        propertyId: propertyId,
        shares: property.effectiveMinimumShares,
      );
    } finally {
      setBusy(false);
    }
  }

  void onBackPressed() {
    Navigator.of(AppConstants.globalNavKey.currentContext!).pop();
  }

  void onSharePressed() {}

  void onDocumentDownloadPressed(String docId) {}

  void onDocumentViewPressed(String docId) {}

  void onReadMorePressed() {
    toggleAboutExpanded();
  }

  void playVideo([String? url]) {
    final videoUrl = url?.trim().isEmpty ?? true
        ? (_property?.video ?? '')
        : url!.trim();
    if (videoUrl.isEmpty) return;
    RoutingHelper.pushToScreen(
      screen: PropertyVideoPlayerView(
        videoUrl: videoUrl,
        propertyName: _property?.name,
      ),
      fullscreenDialog: true,
    );
  }
}
