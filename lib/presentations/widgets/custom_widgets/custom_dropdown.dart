import 'package:flutter/material.dart';
import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class CustomDropdown extends StatelessWidget {
  final String? labelAbove;
  final String hintText;
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    this.labelAbove,
    required this.hintText,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Label Above
        if (labelAbove != null && labelAbove!.isNotEmpty) ...[
          Text(
            labelAbove!,
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px14,
              fontWeight: FontWeight.w600,
              color: ColorConstants.darkGrey,
            ),
          ),
          const SizedBox(height: 6),
        ],

        DropdownButtonFormField<String>(
          value: selectedItem,
          isExpanded: true, // ✅ makes menu width same as dropdown
          dropdownColor: Colors.white, // ✅ menu color same as dropdown
          icon: const Icon(Icons.keyboard_arrow_down),

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,

            hintText: hintText,
            hintStyle: AppTextStyles.regularText(
              fontSize: Dimensions.px12,
              color: ColorConstants.grey,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.px10),
              borderSide: const BorderSide(
                width: 0.5,
                color: ColorConstants.grey,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.px10),
              borderSide: const BorderSide(
                width: 1,
                color: ColorConstants.secondaryColor,
              ),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.px10),
              borderSide: const BorderSide(
                width: 0.5,
                color: ColorConstants.grey,
              ),
            ),
          ),

          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: SizedBox(
                width: double.infinity, // ✅ ensures full width
                child: Text(
                  item,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px14,
                  ),
                ),
              ),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ],
    );
  }
}