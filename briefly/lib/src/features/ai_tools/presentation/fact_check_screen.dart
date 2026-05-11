import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_util.dart';
import 'summarize_screen.dart';

class FactCheckScreen extends StatefulWidget {
  const FactCheckScreen({super.key});

  @override
  State<FactCheckScreen> createState() => _FactCheckScreenState();
}

class _FactCheckScreenState extends State<FactCheckScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  int? _score;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;
    setState(() {
      _isLoading = true;
      _score = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    final text = _controller.text.toLowerCase();
    final emotional = RegExp(
      r'\b(shocking|urgent|unbelievable|exclusive)\b',
    ).hasMatch(text);
    final hasNumbers = RegExp(r'\d').hasMatch(text);
    final score = (62 + (hasNumbers ? 12 : 0) - (emotional ? 18 : 0)).clamp(
      10,
      95,
    );
    setState(() {
      _isLoading = false;
      _score = score;
    });
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
              icon: LucideIcons.shieldCheck,
              title: 'Fact Check',
              subtitle: 'Paste a claim to estimate credibility.',
            ),
            SizedBox(height: context.scaleHeight(18)),
            AiToolInputBox(
              controller: _controller,
              hint: 'Paste a claim, headline, or post...',
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: context.scaleHeight(18)),
            AiToolPrimaryButton(
              icon: LucideIcons.shieldCheck,
              label: _isLoading ? 'Checking...' : 'Check Credibility',
              enabled: canSubmit,
              onTap: _check,
            ),
            if (_score != null) ...[
              SizedBox(height: context.scaleHeight(20)),
              _Verdict(score: _score!),
            ],
          ],
        ),
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  final int score;

  const _Verdict({required this.score});

  @override
  Widget build(BuildContext context) {
    final label = score >= 70
        ? 'Likely credible'
        : score >= 45
        ? 'Needs review'
        : 'High risk';
    final color = score >= 70
        ? AppColors.success
        : score >= 45
        ? const Color(0xFFF59E0B)
        : AppColors.destructive;

    return Container(
      padding: EdgeInsets.all(context.scaleWidth(18)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.h2(context).copyWith(color: color)),
          SizedBox(height: context.scaleHeight(8)),
          Text(
            'Credibility score: $score / 100',
            style: AppTextStyles.body(
              context,
            ).copyWith(fontSize: context.scaleFontSize(14)),
          ),
          SizedBox(height: context.scaleHeight(14)),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: context.scaleHeight(8),
              color: color,
              backgroundColor: AppColors.silver08,
            ),
          ),
        ],
      ),
    );
  }
}
