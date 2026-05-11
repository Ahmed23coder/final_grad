import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_util.dart';

enum _SummaryStyle { brief, detailed, bullets }

class SummarizeScreen extends StatefulWidget {
  const SummarizeScreen({super.key});

  @override
  State<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends State<SummarizeScreen> {
  final _controller = TextEditingController();
  _SummaryStyle _style = _SummaryStyle.brief;
  bool _isLoading = false;
  String? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _summarize() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;
    setState(() {
      _isLoading = true;
      _result = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final summary = _buildSummary(_controller.text.trim(), _style);
    setState(() {
      _isLoading = false;
      _result = summary;
    });

    // Persist to Supabase
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        await Supabase.instance.client.from('ai_summaries').insert({
          'user_id': user.id,
          'source_text': _controller.text.trim(),
          'summary': summary,
          'style': _style.name,
          'language': 'en',
          'provider': 'gemini',
        });
      } catch (e, st) {
        developer.log('ai_summaries insert failed', name: 'summarize', error: e, stackTrace: st);
      }
    }
  }

  String _buildSummary(String text, _SummaryStyle style) {
    final compact = text.replaceAll(RegExp(r'\s+'), ' ');
    final preview = compact.length > 180
        ? '${compact.substring(0, 180)}...'
        : compact;
    switch (style) {
      case _SummaryStyle.brief:
        return 'Brief summary: $preview';
      case _SummaryStyle.detailed:
        return 'Detailed summary: $preview\n\nMain idea: the text focuses on the most important claims, context, and possible impact.';
      case _SummaryStyle.bullets:
        return '- Main topic: $preview\n- Key value: quick understanding\n- Next step: verify important details from the source';
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _controller.text.trim().isNotEmpty && !_isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            context.scaleWidth(20),
            context.scaleHeight(16),
            context.scaleWidth(20),
            context.scaleHeight(128),
          ),
          children: [
            const AiToolHeader(
              icon: LucideIcons.sparkles,
              title: 'AI Summarize',
              subtitle: 'Paste text and get a cleaner summary.',
            ),
            SizedBox(height: context.scaleHeight(18)),
            AiToolInputBox(
              controller: _controller,
              hint: 'Paste article text here...',
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: context.scaleHeight(16)),
            Text('SUMMARY STYLE', style: AppTextStyles.sectionLabel(context)),
            SizedBox(height: context.scaleHeight(10)),
            Row(
              children: _SummaryStyle.values.map((style) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: style == _SummaryStyle.bullets
                          ? 0
                          : context.scaleWidth(8),
                    ),
                    child: _ChoicePill(
                      label: _styleLabel(style),
                      selected: _style == style,
                      onTap: () => setState(() => _style = style),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.scaleHeight(18)),
            AiToolPrimaryButton(
              icon: LucideIcons.sparkles,
              label: _isLoading ? 'Summarizing...' : 'Summarize',
              enabled: canSubmit,
              onTap: _summarize,
            ),
            if (_result != null) ...[
              SizedBox(height: context.scaleHeight(20)),
              _ResultCard(title: 'Summary', text: _result!),
            ],
          ],
        ),
      ),
    );
  }

  String _styleLabel(_SummaryStyle style) {
    switch (style) {
      case _SummaryStyle.brief:
        return 'Brief';
      case _SummaryStyle.detailed:
        return 'Detailed';
      case _SummaryStyle.bullets:
        return 'Bullets';
    }
  }
}

class AiToolHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AiToolHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryAccent,
              size: context.scaleWidth(22),
            ),
            SizedBox(width: context.scaleWidth(10)),
            Text(
              title,
              style: AppTextStyles.h1(
                context,
              ).copyWith(fontSize: context.scaleFontSize(24)),
            ),
          ],
        ),
        SizedBox(height: context.scaleHeight(4)),
        Text(
          subtitle,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.silverSecondaryLabel,
            fontSize: context.scaleFontSize(13),
          ),
        ),
      ],
    );
  }
}

class AiToolInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  const AiToolInputBox({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.scaleHeight(190),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: AppTextStyles.inputText(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextStyles.body(context).copyWith(
            color: AppColors.silverPlaceholder,
            fontSize: context.scaleFontSize(14),
          ),
          contentPadding: EdgeInsets.all(context.scaleWidth(16)),
        ),
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        height: context.scaleHeight(42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryAccent : AppColors.card,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selected ? AppColors.primaryAccent : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.buttonLabel(context).copyWith(
            color: selected
                ? AppColors.primaryForeground
                : AppColors.silverSecondaryLabel,
            fontSize: context.scaleFontSize(12),
          ),
        ),
      ),
    );
  }
}

class AiToolPrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const AiToolPrimaryButton({
    super.key,
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: enabled ? onTap : null,
      child: Container(
        height: context.scaleHeight(50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryAccent : AppColors.silver08,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: enabled
                  ? AppColors.primaryForeground
                  : AppColors.silverDisabled,
              size: context.scaleWidth(16),
            ),
            SizedBox(width: context.scaleWidth(8)),
            Text(
              label,
              style: AppTextStyles.buttonLabel(context).copyWith(
                color: enabled
                    ? AppColors.primaryForeground
                    : AppColors.silverDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String text;

  const _ResultCard({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaleWidth(18)),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardLabel(context)),
          SizedBox(height: context.scaleHeight(10)),
          Text(
            text,
            style: AppTextStyles.body(
              context,
            ).copyWith(fontSize: context.scaleFontSize(14)),
          ),
        ],
      ),
    );
  }
}
