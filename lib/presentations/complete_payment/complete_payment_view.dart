import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/constants/app_text_style.dart';
import '../../core/constants/dimension_constants.dart';
import '../../core/models/created_investment_model.dart';
import '../../core/utils/base_view.dart';
import 'complete_payment_view_model.dart';

class CompletePaymentView extends StatelessWidget {
  final CreatedInvestment investment;

  const CompletePaymentView({super.key, required this.investment});

  static String formatFullCurrency(double value) {
    final str = value.toInt().toString();
    final len = str.length;
    String formatted = '';
    for (int i = 0; i < len; i++) {
      final fromRight = len - i;
      if (i > 0 &&
          ((fromRight > 3 && fromRight % 2 == 1) || fromRight == 4)) {
        formatted += ',';
      }
      formatted += str[i];
    }
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => CompletePaymentViewModel(investment),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(vm),
                        const SizedBox(height: 18),
                        _buildAmountCard(vm),
                        const SizedBox(height: 22),
                        Text(
                          'Choose Payment Method',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px16,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildMethodCards(vm),
                        const SizedBox(height: 16),
                        if (vm.selectedMethod == PaymentMethodType.upi)
                          _buildUpiSection(vm)
                        else
                          _buildBankSection(vm),
                        const SizedBox(height: 20),
                        if (vm.investment.bankName.isNotEmpty) ...[
                          _buildReadOnlyRow(
                            'Bank Name',
                            vm.investment.bankName,
                          ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          'Payment Reference / UTR',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px15,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.paymentReferenceCtrl,
                          onChanged: vm.onReferenceChanged,
                          decoration: InputDecoration(
                            hintText: 'Enter UTR / transaction reference',
                            hintStyle: AppTextStyles.regularText(
                              fontSize: Dimensions.px14,
                              color: const Color(0xFF9CA3AF),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the transaction reference generated after payment.',
                          style: AppTextStyles.regularText(
                            fontSize: Dimensions.px12,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Payment Screenshot',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px15,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildUploadBox(vm),
                        const SizedBox(height: 16),
                        _buildSecureNote(),
                        if (vm.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            vm.errorMessage!,
                            style: AppTextStyles.regularText(
                              fontSize: Dimensions.px13,
                              color: Colors.red,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: vm.canSubmit
                                ? vm.submitPaymentProof
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              disabledBackgroundColor: const Color(
                                0xFF9BB8B4,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: vm.isSubmitting
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Submit Payment Proof',
                                    style: AppTextStyles.boldText(
                                      fontSize: Dimensions.px16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(CompletePaymentViewModel vm) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF0F766E),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complete Your Payment',
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px20,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Make the payment and submit your transaction details.',
                style: AppTextStyles.regularText(
                  fontSize: Dimensions.px13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: vm.onClose,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.close, size: 18, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(CompletePaymentViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AMOUNT PAYABLE',
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px11,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatFullCurrency(vm.investment.amount),
                  style: AppTextStyles.boldText(
                    fontSize: Dimensions.px28,
                    color: const Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              color: Color(0xFF0F766E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCards(CompletePaymentViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: _methodCard(
            selected: vm.selectedMethod == PaymentMethodType.bankTransfer,
            icon: Icons.account_balance_outlined,
            iconLabel: null,
            title: 'Bank Transfer',
            subtitle: 'Transfer directly to our bank',
            buttonLabel: 'Select Bank Transfer',
            onTap: () => vm.selectMethod(PaymentMethodType.bankTransfer),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _methodCard(
            selected: vm.selectedMethod == PaymentMethodType.upi,
            icon: null,
            iconLabel: 'QR',
            title: 'UPI / QR Code',
            subtitle: 'Scan and make payment',
            buttonLabel: 'Select UPI / QR',
            onTap: () => vm.selectMethod(PaymentMethodType.upi),
          ),
        ),
      ],
    );
  }

  Widget _methodCard({
    required bool selected,
    required IconData? icon,
    required String? iconLabel,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F8F3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF0F766E) : const Color(0xFFE5E7EB),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  alignment: Alignment.center,
                  child: icon != null
                      ? Icon(icon, size: 18, color: const Color(0xFF0F766E))
                      : Text(
                          iconLabel ?? '',
                          style: AppTextStyles.boldText(
                            fontSize: Dimensions.px11,
                            color: const Color(0xFF0F766E),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.boldText(
                          fontSize: Dimensions.px13,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.regularText(
                          fontSize: Dimensions.px11,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0F766E)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                buttonLabel,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px12,
                  color: selected ? Colors.white : const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpiSection(CompletePaymentViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            'Scan QR Code to Pay',
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px18,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Scan the QR code using your UPI app.',
            style: AppTextStyles.regularText(
              fontSize: Dimensions.px13,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 168,
            height: 168,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: vm.qrCodeUrl.isEmpty
                  ? const ColoredBox(
                      color: Color(0xFFF3F4F6),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        size: 72,
                        color: Color(0xFF9CA3AF),
                      ),
                    )
                  : Image.network(
                      vm.qrCodeUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFFF3F4F6),
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 72,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
            ),
          ),
          if (vm.upiId.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'UPI ID',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px12,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              vm.upiId,
              style: AppTextStyles.boldText(
                fontSize: Dimensions.px14,
                color: const Color(0xFF111827),
              ),
            ),
          ],
          if (vm.isLoadingPaymentSettings) ...[
            const SizedBox(height: 12),
            const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBankSection(CompletePaymentViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Account Details',
                      style: AppTextStyles.boldText(
                        fontSize: Dimensions.px16,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Use these details to complete your transfer.',
                      style: AppTextStyles.regularText(
                        fontSize: Dimensions.px12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.account_balance_outlined,
                color: Color(0xFF0F766E),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDetailRow('Account Name', vm.accountName.isEmpty ? vm.investment.accountName : vm.accountName),
          _buildDetailRow('Account Number', vm.accountNumber.isEmpty ? vm.investment.accountNumber : vm.accountNumber),
          _buildDetailRow('IFSC Code', vm.ifscCode.isEmpty ? vm.investment.ifsc : vm.ifscCode),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.regularText(
                    fontSize: Dimensions.px14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
              Text(
                value.isEmpty ? '—' : value,
                style: AppTextStyles.boldText(
                  fontSize: Dimensions.px14,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.boldText(
              fontSize: Dimensions.px15,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBox(CompletePaymentViewModel vm) {
    final hasFile = vm.screenshot != null;
    return GestureDetector(
      onTap: vm.pickScreenshot,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            style: BorderStyle.solid,
          ),
        ),
        child: hasFile
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.file(vm.screenshot!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 28,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Payment Screenshot',
                    style: AppTextStyles.boldText(
                      fontSize: Dimensions.px14,
                      color: const Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG or JPEG',
                    style: AppTextStyles.regularText(
                      fontSize: Dimensions.px12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSecureNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: Color(0xFF0F766E),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your payment details are securely submitted for admin verification. Your investment will be processed after payment verification.',
              style: AppTextStyles.regularText(
                fontSize: Dimensions.px12,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
