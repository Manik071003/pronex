import 'package:flutter/material.dart';

import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';


/// Bottom sheet for confirming block action. Matches design with:
/// - Block icon in circular beige background
/// - "Block User?" title
/// - "They will no longer be able to contact you." description
/// - Cancel and Block buttons
class BlockBottomSheet extends StatelessWidget {
  final String userName;
  final VoidCallback? onBlock;
  final VoidCallback? onCancel;

  const BlockBottomSheet({
    super.key,
    this.userName = 'User',
    this.onBlock,
    this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    String userName = 'User',
    VoidCallback? onBlock,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlockBottomSheet(
        userName: userName,
        onBlock: onBlock,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              Dimensions.px20,
              Dimensions.px24,
              Dimensions.px20,
              Dimensions.px24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  padding: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: ColorConstants.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: ColorConstants.radicalRed,
                    size: 28,
                  ),
                ),
                const SizedBox(height: Dimensions.px12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                      'Block User?',
                      style: AppTextStyles.mediumText(
                        fontSize: Dimensions.px18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.px12),
                Text(
                  'They will no longer be able to contact you.',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px14,
                    color: ColorConstants.greyTextColor,
                  ),
                ),
                const SizedBox(height: Dimensions.px24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onCancel?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorConstants.primaryAppColor,
                          side: const BorderSide(
                            color: ColorConstants.primaryAppColor,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.px12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.mediumText(
                            fontSize: Dimensions.px15,
                            color: ColorConstants.primaryAppColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.px12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onBlock?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primaryAppColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.px12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'Block',
                          style: AppTextStyles.mediumText(
                            fontSize: Dimensions.px15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
