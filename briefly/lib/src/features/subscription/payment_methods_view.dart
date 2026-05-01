import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:briefly/src/core/theme/app_colors.dart';
import 'package:briefly/src/core/routes/app_router.dart';
import 'package:briefly/src/core/mvvm/view_model_builder.dart';
import 'package:briefly/src/core/utils/app_animations.dart';
import 'package:briefly/src/core/utils/responsive_util.dart';
import 'package:briefly/src/core/utils/ui_feedback.dart';
import 'package:briefly/src/domain/repositories/profile_repository.dart';
import 'package:briefly/src/domain/models/payment_method.dart';
import '../profile/cubits/subscription/payment_methods_viewmodel.dart';
import 'widgets/standard_subscription_header.dart';
import 'widgets/subscription_widgets.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentMethodsViewModel>.reactive(
      viewModelBuilder: () =>
          PaymentMethodsViewModel(context.read<ProfileRepository>()),
      onModelReady: (vm) => vm.init(),
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: vm.isBusy
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC0C0C0)),
                )
              : SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const StandardSubscriptionHeader(
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment options',
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSecurityBanner(context),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildSavedCards(context, vm),
                              SizedBox(height: context.scaleHeight(16)),
                              _buildAddCardButton(context, vm),
                              SizedBox(height: context.scaleHeight(20)),
                              _buildBillingInfo(context),
                              SizedBox(height: context.scaleHeight(100)),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomCTA(context, vm),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ═══ SECURITY BANNER ═══
  Widget _buildSecurityBanner(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(context.scaleWidth(18)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF34d399).withValues(alpha: 0.05),
          border: Border.all(
            color: const Color(0xFF34d399).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF34d399).withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                LucideIcons.shieldCheck,
                size: 20,
                color: Color(0xFF34d399),
              ),
            ),
            SizedBox(width: context.scaleWidth(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank-Grade Security',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF34d399),
                    ),
                  ),
                  SizedBox(height: context.scaleHeight(2)),
                  Text(
                    'Your data is encrypted and handled securely.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: context.scaleFontSize(11),
                      color: const Color(0xFF34d399).withValues(alpha: 0.70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══ SAVED CARDS ═══
  Widget _buildSavedCards(BuildContext context, PaymentMethodsViewModel vm) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('SAVED CARDS'),
          SizedBox(height: context.scaleHeight(12)),
          ...vm.paymentMethods.asMap().entries.map((entry) {
            final m = entry.value;
            final isSelected = vm.selectedMethodId == m.id;
            return PaymentCardTile(
              brand: m.brandLabel,
              last4: m.last4,
              holderName: m.holderName,
              expiry: m.expiryDate,
              brandColor: m.brandColor,
              isDefault: m.isDefault,
              isSelected: isSelected,
              onTap: () => vm.selectMethod(m.id),
              onDelete: () {
                // Handle delete
              },
            );
          }),
        ],
      ),
    );
  }

  // ═══ ADD CARD BUTTON ═══
  Widget _buildAddCardButton(BuildContext context, PaymentMethodsViewModel vm) {
    return AddCardDashedButton(onTap: () => _showAddCardSheet(context, vm));
  }

  // ═══ BILLING INFO ═══
  Widget _buildBillingInfo(BuildContext context) {
    return PageEntranceAnimation(
      delay: const Duration(milliseconds: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubSectionLabel('BILLING INFORMATION'),
          SizedBox(height: context.scaleHeight(12)),
          SubCard(
            child: Column(
              children: [
                BillingInfoRow(
                  label: 'Billing email',
                  value: 'ahmed@email.com',
                  onTap: () => UiFeedback.showComingSoon(
                    context,
                    'Edit billing email',
                  ),
                ),
                BillingInfoRow(
                  label: 'Billing address',
                  value: 'Not set',
                  onTap: () => UiFeedback.showComingSoon(
                    context,
                    'Edit billing address',
                  ),
                ),
                BillingInfoRow(
                  label: 'Tax ID',
                  value: 'Not set',
                  onTap: () => UiFeedback.showComingSoon(
                    context,
                    'Edit tax ID',
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══ BOTTOM CTA ═══
  Widget _buildBottomCTA(BuildContext context, PaymentMethodsViewModel vm) {
    return GradientCtaBackdrop(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubPrimaryButton(
            label: 'Confirm Payment Method',
            iconRight: LucideIcons.arrowRight,
            enabled: vm.selectedMethodId != null,
            onTap: vm.selectedMethodId != null
                ? () => context.push(AppRouter.confirmation)
                : null,
          ),
          SizedBox(height: context.scaleHeight(12)),
          Text(
            'Your card won\'t be charged until the final step',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: context.scaleFontSize(11),
              color: AppColors.silverSecondaryLabel,
            ),
          ),
        ],
      ),
    );
  }

  // ═══ ADD CARD BOTTOM SHEET ═══
  void _showAddCardSheet(BuildContext context, PaymentMethodsViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _AddCardSheet(vm: vm, parentContext: ctx),
    );
  }
}

// ────────────────────────────────────────
// ADD CARD SHEET
// ────────────────────────────────────────
class _AddCardSheet extends StatefulWidget {
  final PaymentMethodsViewModel vm;
  final BuildContext parentContext;
  const _AddCardSheet({required this.vm, required this.parentContext});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _cardNumberCtrl.text.length >= 16 &&
      _expiryCtrl.text.length == 5 &&
      _cvvCtrl.text.length >= 3 &&
      _nameCtrl.text.isNotEmpty;

  void _submit() async {
    if (!_canSubmit || _isLoading) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    final newMethod = PaymentMethod(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      type: 'card',
      brand: 'Visa',
      last4: _cardNumberCtrl.text.substring(_cardNumberCtrl.text.length - 4),
      expiryDate: _expiryCtrl.text,
      holderName: _nameCtrl.text,
    );
    widget.vm.addPaymentMethod(newMethod);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SubBottomSheet(
      headerAction: SubBottomSheetCloseButton(
        onTap: () => Navigator.pop(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Card',
            style: TextStyle(
              fontFamily: 'Newsreader',
              fontSize: context.scaleFontSize(18),
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: context.scaleHeight(24)),
          FormInputField(
            label: 'Cardholder Name',
            placeholder: 'Name on card',
            controller: _nameCtrl,
            hasIcon: true,
            icon: LucideIcons.user,
          ),
          SizedBox(height: context.scaleHeight(16)),
          FormInputField(
            label: 'Card Number',
            placeholder: '0000 0000 0000 0000',
            controller: _cardNumberCtrl,
            hasIcon: true,
            icon: LucideIcons.creditCard,
          ),
          SizedBox(height: context.scaleHeight(16)),
          Row(
            children: [
              Expanded(
                child: FormInputField(
                  label: 'Expiry',
                  placeholder: 'MM/YY',
                  controller: _expiryCtrl,
                  inputFormatters: [_ExpiryFormatter()],
                ),
              ),
              SizedBox(width: context.scaleWidth(12)),
              Expanded(
                child: FormInputField(
                  label: 'CVV',
                  placeholder: '•••',
                  controller: _cvvCtrl,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaleHeight(24)),
          TermsCheckbox(
            isChecked: true, // Assuming default true for now or state managed
            onChanged: (val) {},
          ),
          SizedBox(height: context.scaleHeight(32)),
          FormSubmitButton(
            label: 'Add Card',
            isLoading: _isLoading,
            enabled: _canSubmit,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

// ── Expiry auto-slash formatter ──
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i < text.length - 1) buffer.write('/');
    }
    final result = buffer.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
