import 'package:flutter/material.dart';
import '../../core/constants/app_text_style.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/models/portfolio_model.dart';
import '../portfolio/portfolio_view.dart';

class KycDocumentsPage extends StatelessWidget {
  final List<PortfolioDocument> documents;

  const KycDocumentsPage({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    final available = documents
        .where((document) => document.url.trim().isNotEmpty)
        .toList();
    return Scaffold(
      backgroundColor: ColorConstants.white,
      appBar: AppBar(
        title: Text(
          'Documents & Statements',
          style: AppTextStyles.boldText(
            fontSize: Dimensions.px18,
            color: ColorConstants.pronexTextDark,
          ),
        ),
        backgroundColor: ColorConstants.white,
        foregroundColor: ColorConstants.pronexTextDark,
        elevation: 0,
      ),
      body: available.isEmpty
          ? const SizedBox.shrink()
          : ListView(
              padding: const EdgeInsets.all(Dimensions.px20),
              children: [
                Container(
                  padding: const EdgeInsets.all(Dimensions.px28),
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(Dimensions.px24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: Dimensions.px20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            color: ColorConstants.pronexPrimary,
                            size: Dimensions.px20,
                          ),
                          const SizedBox(width: Dimensions.px12),
                          Text(
                            'Uploaded Documents',
                            style: AppTextStyles.boldText(
                              fontSize: Dimensions.px19,
                              color: ColorConstants.pronexTextDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.px20),
                      ...available.map(
                        (document) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    PortfolioDocumentPage(document: document),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: Dimensions.px16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  color: ColorConstants.pronexPrimary,
                                  size: Dimensions.px20,
                                ),
                                const SizedBox(width: Dimensions.px12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document.type.toUpperCase(),
                                        style: AppTextStyles.regularText(
                                          fontSize: Dimensions.px12,
                                          color: ColorConstants.pronexTextGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        document.name,
                                        style: AppTextStyles.semiBoldText(
                                          fontSize: Dimensions.px15,
                                          color: ColorConstants.pronexTextDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.visibility_outlined,
                                  color: ColorConstants.pronexPrimary,
                                  size: Dimensions.px18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
