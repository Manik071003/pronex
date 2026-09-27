import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import 'explore_view_model.dart';

Future<void> showExploreFilterSheet(
  BuildContext context,
  ExploreViewModel viewModel,
) {
  viewModel.ensureLocations();
  return showDialog<void>(
    context: context,
    barrierColor: const Color(0xFFF3FAF6).withValues(alpha: 0.72),
    builder: (context) => ExploreFilterSheet(viewModel: viewModel),
  );
}

class ExploreFilterSheet extends StatefulWidget {
  final ExploreViewModel viewModel;

  const ExploreFilterSheet({super.key, required this.viewModel});

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  static const _types = <(String, String)>[
    ('', 'All Types'),
    ('commercial', 'Commercial'),
    ('residential', 'Residential'),
    ('industrial', 'Industrial'),
  ];

  late final Set<String> _cities;
  late String _type;
  late String _funding;
  double? _maxPrice;
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    final viewModel = widget.viewModel;
    _cities = {...viewModel.selectedCities};
    _type = viewModel.selectedPropertyType;
    _funding = viewModel.selectedFundingStatus;
    _maxPrice = viewModel.selectedMaxPrice;
  }

  String get _budgetLabel {
    final price = _maxPrice;
    if (price == null) return 'Any';
    return '₹${(price / 100000).toStringAsFixed(1)}L';
  }

  Future<void> _apply() async {
    setState(() => _applying = true);
    final applied = await widget.viewModel.applyExploreFilters(
      cities: _cities,
      type: _type,
      maxPrice: _maxPrice,
      fundingStatus: _funding,
    );
    if (!mounted) return;
    setState(() => _applying = false);
    if (applied) Navigator.of(context).pop();
  }

  Future<void> _reset() async {
    setState(() {
      _cities.clear();
      _type = '';
      _funding = 'All';
      _maxPrice = null;
    });
    await widget.viewModel.resetExploreFilters();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return Dialog(
      backgroundColor: ColorConstants.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Dimensions.px16,
        vertical: Dimensions.px24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.px28),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Dimensions.px20,
            Dimensions.px20,
            Dimensions.px20,
            Dimensions.px16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFF1B6B45),
                    size: 22,
                  ),
                  const SizedBox(width: Dimensions.px8),
                  Text(
                    'Filters',
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px20,
                      color: ColorConstants.pronexTextDark,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _applying ? null : _reset,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: Color(0xFF1B6B45),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Reset',
                          style: AppTextStyles.semiBoldText(
                            fontSize: Dimensions.px14,
                            color: const Color(0xFF1B6B45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.px14),
              const Divider(color: Color(0xFFE7F3EC), height: 1),
              const SizedBox(height: Dimensions.px18),
              _label('LOCATIONS (CITY / STATE)'),
              const SizedBox(height: Dimensions.px10),
              ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  if (viewModel.isLoadingLocations &&
                      viewModel.locationOptions.isEmpty) {
                    return Text(
                      'Fetching locations...',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: const Color(0xFFB0B8C4),
                      ).copyWith(fontStyle: FontStyle.italic),
                    );
                  }
                  if (viewModel.locationOptions.isEmpty) {
                    return Text(
                      'No locations found',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px13,
                        color: ColorConstants.pronexTextGrey,
                      ),
                    );
                  }
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 160),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: viewModel.locationOptions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: Dimensions.px8),
                      itemBuilder: (context, index) {
                        final city = viewModel.locationOptions[index];
                        final selected = _cities.contains(city);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _cities.remove(city);
                              } else {
                                _cities.add(city);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: selected,
                                  activeColor: const Color(0xFF1B6B45),
                                  side: const BorderSide(
                                    color: Color(0xFFD1D5DB),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _cities.add(city);
                                      } else {
                                        _cities.remove(city);
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: Dimensions.px10),
                              Expanded(
                                child: Text(
                                  city,
                                  style: AppTextStyles.regularText(
                                    fontSize: Dimensions.px15,
                                    color: const Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: Dimensions.px22),
              _label('PROPERTY TYPE'),
              const SizedBox(height: Dimensions.px10),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFBFDFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.px16,
                    vertical: Dimensions.px14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                    borderSide: const BorderSide(color: Color(0xFFD7EBE3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.px16),
                    borderSide: const BorderSide(color: Color(0xFF1B6B45)),
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF9CA3AF),
                ),
                items: _types
                    .map(
                      (type) => DropdownMenuItem(
                        value: type.$1,
                        child: Text(
                          type.$2,
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.pronexTextDark,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _type = value);
                },
              ),
              const SizedBox(height: Dimensions.px22),
              Row(
                children: [
                  _label('BUDGET RANGE'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.px10,
                      vertical: Dimensions.px4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F6EE),
                      borderRadius: BorderRadius.circular(Dimensions.px10),
                    ),
                    child: Text(
                      _budgetLabel,
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px13,
                        color: const Color(0xFF1B6B45),
                      ),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF1B6B45),
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  thumbColor: const Color(0xFF1B6B45),
                  overlayColor: const Color(0x331B6B45),
                  trackHeight: 4,
                ),
                child: Slider(
                  min: ExploreViewModel.budgetMin,
                  max: ExploreViewModel.budgetMax,
                  divisions: 999,
                  value: _maxPrice ?? ExploreViewModel.budgetMax,
                  onChanged: (value) {
                    setState(() {
                      _maxPrice = value >= ExploreViewModel.budgetMax
                          ? null
                          : value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹1L',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    '₹10Cr+',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.px18),
              _label('FUNDING STATUS'),
              const SizedBox(height: Dimensions.px12),
              Row(
                children: [
                  _fundingChip('All'),
                  const SizedBox(width: Dimensions.px10),
                  _fundingChip('In Progress'),
                ],
              ),
              const SizedBox(height: Dimensions.px22),
              SizedBox(
                width: double.infinity,
                height: Dimensions.px52,
                child: ElevatedButton(
                  onPressed: _applying ? null : _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6B45),
                    disabledBackgroundColor: const Color(0xFF1B6B45),
                    foregroundColor: ColorConstants.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.px16),
                    ),
                  ),
                  child: _applying
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Apply Filters',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px16,
                            color: ColorConstants.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: AppTextStyles.boldText(
        fontSize: Dimensions.px12,
        color: const Color(0xFF6B7280),
      ).copyWith(letterSpacing: 0.6),
    );
  }

  Widget _fundingChip(String label) {
    final selected = _funding == label;
    return GestureDetector(
      onTap: () => setState(() => _funding = label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.px18,
          vertical: Dimensions.px10,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1B6B45) : ColorConstants.white,
          borderRadius: BorderRadius.circular(Dimensions.px14),
          border: Border.all(
            color: selected
                ? const Color(0xFF1B6B45)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.semiBoldText(
            fontSize: Dimensions.px14,
            color: selected
                ? ColorConstants.white
                : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}
