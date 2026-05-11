import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/colors/app_colors.dart';
import '../../core/radius/app_radius.dart';
import '../../core/typography/app_text_styles.dart';
import '../../core/utils/app_animations.dart';
import '../../core/utils/responsive_util.dart';
import '../../../models/domain/fact_check_result.dart';
import '../../../models/ui/input_mode.dart';
import '../cubits/fact_check_cubit.dart';
import '../cubits/fact_check_state.dart';

/// Fact Check / Fake Detection â€” standalone credibility analysis tool.
class FactCheckScreen extends StatelessWidget {
  const FactCheckScreen({super.key});

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
                child: BlocBuilder<FactCheckCubit, FactCheckState>(
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
                            onModeChanged: (mode) =>
                                context.read<FactCheckCubit>().setMode(mode),
                          ),

                          SizedBox(height: context.scaleHeight(16)),

                          // Input Area
                          if (state.mode == InputMode.text)
                            _TextInputArea(state: state)
                          else
                            _ImageInputArea(state: state),

                          SizedBox(height: context.scaleHeight(16)),

                          // Analyze Button
                          _AnalyzeButton(state: state),

                          // Result
                          if (state.result != null) ...[
                            SizedBox(height: context.scaleHeight(24)),
                            _VerdictCard(state: state),
                            SizedBox(height: context.scaleHeight(20)),
                            _AnalysisBreakdown(state: state),
                            SizedBox(height: context.scaleHeight(20)),
                            _ResetButton(),
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
                LucideIcons.shieldCheck,
                color: AppColors.primaryAccent,
                size: context.scaleWidth(22),
              ),
              SizedBox(width: context.scaleWidth(10)),
              Text(
                'Fact Check',
                style: AppTextStyles.h1(context),
              ),
            ],
          ),
          SizedBox(height: context.scaleHeight(4)),
          Text(
            'Paste text or upload an image to verify',
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
// MODE TOGGLE  (shared pattern with Summarize Picker)
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
            color: isActive ? AppColors.primaryAccent : AppColors.borderColor,
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
  final FactCheckState state;

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
                    context.read<FactCheckCubit>().setText(text),
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
                      'Paste the article text, claim, social media post, or any content you want to fact-check...',
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
            if (hasText)
              Positioned(
                top: context.scaleHeight(12),
                right: context.scaleWidth(12),
                child: GestureDetector(
                  onTap: () {
                    _controller.clear();
                    context.read<FactCheckCubit>().clearText();
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
  final FactCheckState state;

  const _ImageInputArea({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.imagePath != null) {
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
            child: Center(
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
              onTap: () => context.read<FactCheckCubit>().clearImage(),
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

    return PressScaleAnimation(
      onTap: () => context.read<FactCheckCubit>().setImage('selected_image.jpg'),
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
// ANALYZE BUTTON (CTA)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AnalyzeButton extends StatelessWidget {
  final FactCheckState state;

  const _AnalyzeButton({required this.state});

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
            'Analyzing...',
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
            LucideIcons.shieldCheck,
            size: context.scaleWidth(16),
            color: isDisabled
                ? AppColors.mutedForeground.withValues(alpha: 0.4)
                : AppColors.primaryForeground,
          ),
          SizedBox(width: context.scaleWidth(8)),
          Text(
            'Check Credibility',
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
      onTap: () => context.read<FactCheckCubit>().analyze(),
      scaleOnPress: 0.95,
      child: button,
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// VERDICT CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _VerdictCard extends StatelessWidget {
  final FactCheckState state;

  const _VerdictCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final result = state.result!;
    final verdictColor = result.verdict.color;

    return PageEntranceAnimation(
      slideOffset: 20,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.scaleWidth(20)),
        decoration: BoxDecoration(
          color: verdictColor.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(AppRadius.settingsGroupValue),
          border: Border.all(
            color: verdictColor.withValues(alpha: 0.25),
            width: AppRadius.buttonValue,
          ),
        ),
        child: Column(
          children: [
            // Verdict Icon + Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  result.verdict.icon,
                  size: context.scaleWidth(24),
                  color: verdictColor,
                ),
                SizedBox(width: context.scaleWidth(10)),
                Text(
                  result.verdict.label,
                  style: TextStyle(
                    fontFamily: 'Newsreader',
                    fontWeight: FontWeight.w700,
                    fontSize: context.scaleFontSize(22),
                    color: verdictColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.scaleHeight(8)),

            // Score label
            Text(
              'Credibility Score: ${result.credibilityScore} / 100',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: context.scaleFontSize(13),
                color: AppColors.bodyText,
              ),
            ),

            SizedBox(height: context.scaleHeight(16)),

            // Animated progress bar
            _AnimatedProgressBar(
              score: result.credibilityScore,
              color: verdictColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final int score;
  final Color color;

  const _AnimatedProgressBar({
    required this.score,
    required this.color,
  });

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progress = Tween<double>(
      begin: 0,
      end: widget.score / 100,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) {
        return Container(
          height: context.scaleHeight(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.foreground.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pillValue),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: _progress.value,
            child: Container(
              height: context.scaleHeight(8),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(AppRadius.pillValue),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// ANALYSIS BREAKDOWN
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AnalysisBreakdown extends StatelessWidget {
  final FactCheckState state;

  const _AnalysisBreakdown({required this.state});

  @override
  Widget build(BuildContext context) {
    final result = state.result!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: context.scaleWidth(4)),
              child: Text(
                'ANALYSIS BREAKDOWN',
                style: AppTextStyles.sectionLabel(context),
              ),
            ),
            // Copy button
            GestureDetector(
              onTap: () {
                final text = result.factors
                    .map((f) => '${f.name}: ${f.status.label} â€” ${f.detail}')
                    .join('\n');
                Clipboard.setData(ClipboardData(text: text));
                context.read<FactCheckCubit>().copyResult();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleWidth(10),
                  vertical: context.scaleHeight(5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.foreground.withValues(alpha: 0.05),
                  borderRadius:
                      BorderRadius.circular(AppRadius.pillValue),
                  border: Border.all(
                    color: AppColors.foreground.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      state.hasCopied
                          ? LucideIcons.check
                          : LucideIcons.copy,
                      size: context.scaleWidth(11),
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
                        fontSize: context.scaleFontSize(10),
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

        SizedBox(height: context.scaleHeight(12)),

        // Factor cards
        StaggeredListAnimation(
          itemDelay: const Duration(milliseconds: 80),
          children: result.factors.map((factor) {
            return _FactorCard(factor: factor);
          }).toList(),
        ),
      ],
    );
  }
}

class _FactorCard extends StatelessWidget {
  final FactorResult factor;

  const _FactorCard({required this.factor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.scaleHeight(10)),
      padding: EdgeInsets.all(context.scaleWidth(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardValue),
        border: Border.all(
          color: AppColors.borderColor,
          width: AppRadius.buttonValue,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status icon
          Container(
            padding: EdgeInsets.all(context.scaleWidth(6)),
            decoration: BoxDecoration(
              color: factor.status.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              factor.status.icon,
              size: context.scaleWidth(14),
              color: factor.status.color,
            ),
          ),
          SizedBox(width: context.scaleWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.name,
                  style: AppTextStyles.cardLabel(context).copyWith(
                    fontSize: context.scaleFontSize(13),
                  ),
                ),
                SizedBox(height: context.scaleHeight(4)),
                Text(
                  factor.detail,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: context.scaleFontSize(11),
                    height: 1.4,
                    color: AppColors.silverSecondaryLabel,
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

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// RESET BUTTON
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PressScaleAnimation(
      onTap: () => context.read<FactCheckCubit>().reset(),
      scaleOnPress: 0.95,
      child: Container(
        width: double.infinity,
        height: context.scaleHeight(48),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pillValue),
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
              'Check Another',
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
    );
  }
}



