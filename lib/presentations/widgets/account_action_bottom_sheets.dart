import 'package:flutter/material.dart';

import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  const DeleteAccountBottomSheet({
    super.key,
    this.onDelete,
    this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onDelete,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DeleteAccountBottomSheet(
        onDelete: onDelete,
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
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: ColorConstants.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(height: Dimensions.px12),
                Text(
                  'Delete Account?',
                  style: AppTextStyles.mediumText(
                    fontSize: Dimensions.px18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Dimensions.px8),
                Text(
                  'This action is permanent and cannot be undone.',
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
                          onDelete?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
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
                          'Delete',
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

class LogoutBottomSheet extends StatelessWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onCancel;

  const LogoutBottomSheet({
    super.key,
    this.onLogout,
    this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onLogout,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LogoutBottomSheet(
        onLogout: onLogout,
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
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: ColorConstants.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: ColorConstants.primaryAppColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: Dimensions.px12),
                Text(
                  'See You Soon!',
                  style: AppTextStyles.mediumText(
                    fontSize: Dimensions.px18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Dimensions.px8),
                Text(
                  'Do you want to logout now?',
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
                          onLogout?.call();
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
                          'Logout',
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
