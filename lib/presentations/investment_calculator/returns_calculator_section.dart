import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/utils/base_view.dart';
import 'investment_calculator_view_model.dart';

class ReturnsCalculatorSection extends StatelessWidget {
  final String propertyId;
  final String propertyName;
  final int sharePrice;
  final int totalValue;
  final double roi;
  final double rentalYield;
  final int buyingCycle;
  final int minShares;
  final int availableShares;

  const ReturnsCalculatorSection({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.sharePrice,
    required this.totalValue,
    required this.roi,
    required this.rentalYield,
    this.buyingCycle = 5,
    this.minShares = 10,
    this.availableShares = 1000,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => InvestmentCalculatorViewModel(
        propertyId,
        sharePrice: sharePrice.toDouble(),
        totalAssetValue: totalValue.toDouble(),
        roiPercent: roi,
        annualYieldPercent: rentalYield,
        buyingCycle: buyingCycle,
        minimumShares: minShares,
        availableShares: availableShares,
        initialShareQuantity: minShares > 0 ? minShares : 10,
      ),
      builder: (context, vm, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.px16),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.px20),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFBFC),
              borderRadius: BorderRadius.circular(Dimensions.px24),
              border: Border.all(color: const Color(0xFFE1E5EA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Returns Calculator',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px22,
                          color: ColorConstants.pronexTextDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9FBF3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Live Projection',
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px13,
                          color: const Color(0xFF087F5B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.px24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 650;
                    final controls = _buildControls(vm);
                    final results = _buildResults(vm);
                    if (compact) {
                      return Column(
                        children: [
                          controls,
                          const SizedBox(height: 20),
                          results,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: controls),
                        const SizedBox(width: 32),
                        Expanded(child: results),
                      ],
                    );
                  },
                ),
                const SizedBox(height: Dimensions.px22),
                Text(
                  propertyName,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px12,
                    color: ColorConstants.pronexTextGrey,
                  ),
                ),
                const SizedBox(height: Dimensions.px14),
                SizedBox(
                  width: double.infinity,
                  height: Dimensions.px52,
                  child: ElevatedButton(
                    onPressed: vm.isBusy ? null : vm.onProceedToInvest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF087F5B),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF9BB8B4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.px16),
                      ),
                    ),
                    child: vm.isBusy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('PROCEED TO INVEST'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls(InvestmentCalculatorViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SELECT SHARES', style: _labelStyle()),
        const SizedBox(height: 12),
        Row(
          children: [
            _squareButton(Icons.remove_rounded, vm.decrementShares, false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '${vm.shareQuantity}',
                style: AppTextStyles.boldText(
                  fontSize: 28,
                  color: ColorConstants.pronexTextDark,
                ),
              ),
            ),
            _squareButton(Icons.add_rounded, vm.incrementShares, true),
          ],
        ),
        const SizedBox(height: 26),
        Text('OWNERSHIP PERCENTAGE', style: _labelStyle()),
        const SizedBox(height: 12),
        Text(
          '${vm.ownershipPercent.toStringAsFixed(1)}%',
          style: AppTextStyles.boldText(
            fontSize: 28,
            color: ColorConstants.pronexTextDark,
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: (vm.ownershipPercent / 100).clamp(0, 1),
            minHeight: 8,
            backgroundColor: const Color(0xFFDDEBE5),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF087F5B)),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(InvestmentCalculatorViewModel vm) {
    return Column(
      children: [
        _resultTile(
          'Total Investment',
          _formatFullCurrency(vm.investmentAmount),
        ),
        const SizedBox(height: 14),
        _resultTile(
          'Est. Monthly Income',
          _formatFullCurrency(vm.monthlyReturn),
          green: true,
        ),
        const SizedBox(height: 14),
        _resultTile(
          'Projected Exit (5Y)',
          _formatFullCurrency(
            vm.investmentAmount + vm.expectedAnnualReturn * 5,
          ),
        ),
      ],
    );
  }

  Widget _resultTile(String label, String value, {bool green = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEF0F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.regularText(
              fontSize: 14,
              color: const Color(0xFF98A2B3),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: 25,
              color: green
                  ? const Color(0xFF087F5B)
                  : ColorConstants.pronexTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _squareButton(IconData icon, VoidCallback onTap, bool active) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF087F5B) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? const Color(0xFF087F5B) : const Color(0xFFDDE1E6),
          ),
        ),
        child: Icon(
          icon,
          size: 30,
          color: active ? Colors.white : ColorConstants.pronexTextDark,
        ),
      ),
    );
  }

  TextStyle _labelStyle() => AppTextStyles.regularText(
    fontSize: 14,
    color: const Color(0xFF98A2B3),
    fontWeight: FontWeight.w600,
  );

  String _formatFullCurrency(double value) {
    final str = value.toInt().toString();
    final formatted = <String>[];
    for (var i = str.length; i > 0; i -= 2) {
      final start = i - 2 < 0 ? 0 : i - 2;
      formatted.insert(0, str.substring(start, i));
    }
    if (formatted.length > 1 && formatted.first.length == 1) {
      final first = formatted.removeAt(0);
      formatted[0] = '$first${formatted[0]}';
    }
    return '₹${formatted.join(',')}';
  }
}
