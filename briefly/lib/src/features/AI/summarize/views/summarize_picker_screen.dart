import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/colors/app_colors.dart';
import '../../../core/radius/app_radius.dart';
import '../../../core/typography/app_text_styles.dart';
import '../../../core/utils/app_animations.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../../models/domain/summarize_result.dart';
import '../../../../models/ui/input_mode.dart';
import '../cubits/summarize_picker_cubit.dart';
import '../cubits/summarize_picker_state.dart';

/// AI Summarize Picker â€” standalone tool screen (bottom nav tab).
class SummarizePickerScreen extends StatelessWidget {
  const SummarizePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: PageEntranceAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // â”€â”€ Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              _Header(),
              // â”€â”€ Scrollable Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Expanded(
                child: BlocBuilder<SummarizePickerCubit, SummarizePickerState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: context.scaleWidth(20),
                        right: context.scaleWidth(20),
                        top: context.scaleHeight(16),
                        bottom: context.scaleHeight(128),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mode Toggle
                          _ModeToggle(
                            activeMode: state.mode,
                            onModeChanged: (mode) => context
                                .read<SummarizePickerCubit>()
                                .setMode(mode),
                          ),

                          SizedBox(height: context.scaleHeight(16)),

                          // Input Area
                          if (state.mode == InputMode.text)
                            _TextInputArea(state: state)
                          else
                            _ImageInputArea(state: state),

                          SizedBox(height: context.scaleHeight(20)),

                          // Summary Style Picker
                          _SummaryStyleSection(state: state),

                          SizedBox(height: context.scaleHeight(16)),

                          // CTA Button
                          _SummarizeButton(state: state),

                          // Result Card
                          if (state.result != null) ...[
                            SizedBox(height: context.scaleHeight(20)),
                            _ResultCard(state: state),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// HEADER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.scaleWidth(20),
        right: context.scaleWidth(20),
        top: context.scaleHeight(12),
        bottom: context.scaleHeight(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                color: AppColors.primaryAccent,
                size: context.scaleWidth(22),
              ),
              SizedBox(width: context.scaleWidth(10)),
              Text(
                'AI Summarize',
                style: AppTextStyles.h1(context),
              ),
            ],
          ),
          SizedBox(height: context.scaleHeight(4)),
          Text(
            'Paste text or upload an image to summarize',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: context.scaleFontSize(12),
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// MODE TOGGLE  (shared concept, but built inline per Figma)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ModeToggle extends StatelessWidget {
  final InputMode activeMode;
  final ValueChanged<InputMode> onModeChanged;

  const _ModeToggle({
    required this.activeMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeButton(
            icon: LucideIcons.type,
            label: 'Paste Text',
            isActive: activeMode == InputMode.text,
            onTap: () => onModeChanged(InputMode.text),
          ),
        ),
        SizedBox(width: context.scaleWidth(8)),
        Expanded(
          child: _ModeButton(
            icon: LucideIcons.image,
            label: 'Upload Image',
            isActive: activeMode == InputMode.image,
            onTap: () => onModeChanged(InputMode.image),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: context.scaleHeight(43),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryAccent : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          border: Border.all(
            color: isActive
                ? AppColors.primaryAccent
                : AppColors.borderColor,
            width: AppRadius.buttonValue,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.scaleWidth(14),
              color: isActive
                  ? AppColors.primaryForeground
                  : AppColors.mutedForeground,
            ),
            SizedBox(width: context.scaleWidth(8)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(12),
                color: isActive
                    ? AppColors.primaryForeground
                    : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// TEXT INPUT AREA
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TextInputArea extends StatefulWidget {
  final SummarizePickerState state;

  const _TextInputArea({required this.state});

  @override
  State<_TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<_TextInputArea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.state.inputText);
  }

  @override
  void didUpdateWidget(_TextInputArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.inputText != _controller.text) {
      _controller.text = widget.state.inputText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.state.inputText.isNotEmpty;
    final charCount = widget.state.inputText.trim().length;
    final isWarning = hasText && charCount < 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: context.scaleHeight(176),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius:
                    BorderRadius.circular(AppRadius.settingsGroupValue),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: AppRadius.buttonValue,
                ),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (text) =>
                    context.read<SummarizePickerCubit>().setText(text),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: context.scaleFontSize(14),
                  color: AppColors.foreground,
                  height: 1.43,
                ),
                decoration: InputDecoration(
                  filled: false,
                  hintText:
                      "Paste your article text, news content, or any text you'd like summarized...",
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: context.scaleFontSize(14),
                    color: AppColors.mutedForeground.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.scaleWidth(20),
                    vertical: context.scaleHeight(16),
                  ),
                ),
              ),
            ),
            // Clear button
            if (hasText)
              Positioned(
                top: context.scaleHeight(12),
                right: context.scaleWidth(12),
                child: GestureDetector(
                  onTap: () {
                    _controller.clear();
                    context.read<SummarizePickerCubit>().clearText();
                  },
                  child: Container(
                    padding: EdgeInsets.all(context.scaleWidth(6)),
                    decoration: BoxDecoration(
                      color: AppColors.foreground.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.foreground.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: context.scaleWidth(12),
                      color: AppColors.silverPlaceholder,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: context.scaleHeight(8)),

        // Word counter
        Padding(
          padding: EdgeInsets.only(left: context.scaleWidth(4)),
          child: Text(
            '${widget.state.wordCount} words',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: context.scaleFontSize(10),
              color: isWarning
                  ? const Color(0xFFF59E0B)
                  : AppColors.mutedForeground.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// IMAGE INPUT AREA
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ImageInputArea extends StatelessWidget {
  final SummarizePickerState state;

  const _ImageInputArea({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.imagePath != null) {
      // Preview state
      return Stack(
        children: [
          Container(
            height: context.scaleHeight(176),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius:
                  BorderRadius.circular(AppRadius.settingsGroupValue),
              border: Border.all(
                color: AppColors.borderColor,
                width: AppRadius.buttonValue,
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppRadius.settingsGroupValue - 1),
              child: Icon(
                LucideIcons.image,
                size: context.scaleWidth(48),
                color: AppColors.silverPlaceholder,
              ),
            ),
          ),
          Positioned(
            top: context.scaleHeight(12),
            right: context.scaleWidth(12),
            child: GestureDetector(
              onTap: () =>
                  context.read<SummarizePickerCubit>().clearImage(),
              child: Container(
                padding: EdgeInsets.all(context.scaleWidth(6)),
                decoration: BoxDecoration(
                  color: AppColors.foreground.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.foreground.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(
                  LucideIcons.x,
                  size: context.scaleWidth(12),
                  color: AppColors.silverPlaceholder,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Upload state â€” dashed border
    return PressScaleAnimation(
      onTap: () {
        // Placeholder image selection
        context.read<SummarizePickerCubit>().setImage('selected_image.jpg');
      },
      scaleOnPress: 0.97,
      child: Container(
        height: context.scaleHeight(176),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.5),
          borderRadius:
              BorderRadius.circular(AppRadius.settingsGroupValue),
          border: Border.all(
            color: AppColors.borderColor,
            width: AppRadius.buttonValue,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(context.scaleWidth(16)),
              decoration: BoxDecoration(
                color: AppColors.foreground.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.foreground.withValues(alpha: 0.08),
                ),
              ),
              child: Icon(
                LucideIcons.upload,
                size: context.scaleWidth(24),
                color: AppColors.silverPlaceholder,
              ),
            ),
            SizedBox(height: context.scaleHeight(12)),
            Text(
              'Tap to upload image',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: context.scaleFontSize(12),
                color: AppColors.mutedForeground,
              ),
            ),
            SizedBox(height: context.scaleHeight(4)),
            Text(
              'PNG, JPG up to 10MB',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: context.scaleFontSize(10),
                color: AppColors.silverTimestamp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SUMMARY STYLE PICKER
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SummaryStyleSection extends StatelessWidget {
  final SummarizePickerState state;

  const _SummaryStyleSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label â€” uppercase tracking
        Padding(
          padding: EdgeInsets.only(left: context.scaleWidth(4)),
          child: Text(
            'SUMMARY STYLE',
            style: AppTextStyles.sectionLabel(context),
          ),
        ),
        SizedBox(height: context.scaleHeight(12)),
        Row(
          children: SummaryStyle.values.map((style) {
            final isActive = state.selectedStyle == style;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: style != SummaryStyle.bullets
                      ? context.scaleWidth(8)
                      : 0,
                ),
                child: _StylePill(
                  style: style,
                  isActive: isActive,
                  onTap: () => context
                      .read<SummarizePickerCubit>()
                      .setStyle(style),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StylePill extends StatelessWidget {
  final SummaryStyle style;
  final bool isActive;
  final VoidCallback onTap;

  const _StylePill({
    required this.style,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: onTap,
      scaleOnPress: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: context.scaleHeight(63),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.foreground.withValues(alpha: 0.10)
              : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
          border: Border.all(
            color: isActive
                ? AppColors.primaryAccent.withValues(alpha: 0.30)
                : AppColors.borderColor,
            width: AppRadius.buttonValue,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              style.label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(11),
                color: isActive
                    ? AppColors.foreground
                    : AppColors.mutedForeground,
              ),
            ),
            SizedBox(height: context.scaleHeight(4)),
            Opacity(
              opacity: 0.5,
              child: Text(
                style.description,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: context.scaleFontSize(9),
                  color: isActive
                      ? AppColors.foreground
                      : AppColors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// SUMMARIZE BUTTON (CTA)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SummarizeButton extends StatelessWidget {
  final SummarizePickerState state;

  const _SummarizeButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final canSubmit = state.canSubmit;
    final isLoading = state.isLoading;
    final isDisabled = !canSubmit || isLoading;

    Widget child;
    if (isLoading) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.scaleWidth(16),
            height: context.scaleWidth(16),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.mutedForeground.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(width: context.scaleWidth(10)),
          Text(
            'Summarizing...',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFontSize(14),
              color: AppColors.mutedForeground.withValues(alpha: 0.4),
            ),
          ),
        ],
      );
    } else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.sparkles,
            size: context.scaleWidth(16),
            color: isDisabled
                ? AppColors.mutedForeground.withValues(alpha: 0.4)
                : AppColors.primaryForeground,
          ),
          SizedBox(width: context.scaleWidth(8)),
          Text(
            'Summarize with AI',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: context.scaleFontSize(14),
              color: isDisabled
                  ? AppColors.mutedForeground.withValues(alpha: 0.4)
                  : AppColors.primaryForeground,
            ),
          ),
        ],
      );
    }

    final button = Container(
      height: context.scaleHeight(51),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDisabled
            ? AppColors.foreground.withValues(alpha: 0.05)
            : AppColors.primaryAccent,
        borderRadius: BorderRadius.circular(AppRadius.pillValue),
        border: Border.all(
          color: isDisabled
              ? AppColors.foreground.withValues(alpha: 0.05)
              : AppColors.primaryAccent,
          width: AppRadius.buttonValue,
        ),
      ),
      child: child,
    );

    if (isDisabled) return button;

    return PressScaleAnimation(
      onTap: () => context.read<SummarizePickerCubit>().summarize(),
      scaleOnPress: 0.95,
      child: button,
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// RESULT CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ResultCard extends StatelessWidget {
  final SummarizePickerState state;

  const _ResultCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final result = state.result!;

    return PageEntranceAnimation(
      slideOffset: 20,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.scaleWidth(20)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius:
              BorderRadius.circular(AppRadius.settingsGroupValue),
          border: Border.all(
            color: AppColors.borderColor,
            width: AppRadius.buttonValue,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: context.scaleWidth(16),
                  color: AppColors.primaryAccent,
                ),
                SizedBox(width: context.scaleWidth(8)),
                Expanded(
                  child: Text(
                    '${result.style.label} Summary',
                    style: AppTextStyles.cardLabel(context),
                  ),
                ),
                // Copy button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: result.summary),
                    );
                    context.read<SummarizePickerCubit>().copyResult();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleWidth(12),
                      vertical: context.scaleHeight(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.foreground.withValues(alpha: 0.05),
                      borderRadius:
                          BorderRadius.circular(AppRadius.pillValue),
                      border: Border.all(
                        color:
                            AppColors.foreground.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          state.hasCopied
                              ? LucideIcons.check
                              : LucideIcons.copy,
                          size: context.scaleWidth(12),
                          color: state.hasCopied
                              ? const Color(0xFF10B981)
                              : AppColors.silverSecondaryLabel,
                        ),
                        SizedBox(width: context.scaleWidth(4)),
                        Text(
                          state.hasCopied ? 'Copied' : 'Copy',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: context.scaleFontSize(11),
                            color: state.hasCopied
                                ? const Color(0xFF10B981)
                                : AppColors.silverSecondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.scaleHeight(16)),

            // Summary text
            Text(
              result.summary,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: context.scaleFontSize(14),
                height: 1.7,
                color: AppColors.bodyText,
              ),
            ),

            SizedBox(height: context.scaleHeight(20)),

            // Reset button
            PressScaleAnimation(
              onTap: () => context.read<SummarizePickerCubit>().reset(),
              scaleOnPress: 0.95,
              child: Container(
                width: double.infinity,
                height: context.scaleHeight(44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppRadius.pillValue),
                  border: Border.all(color: AppColors.silverBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.rotateCcw,
                      size: context.scaleWidth(14),
                      color: AppColors.silver70,
                    ),
                    SizedBox(width: context.scaleWidth(8)),
                    Text(
                      'Summarize Another',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: context.scaleFontSize(13),
                        color: AppColors.silver70,
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
  }
}



