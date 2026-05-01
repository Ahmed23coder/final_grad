import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:briefly/src/core/utils/ui_feedback.dart';
import '../../cubits/help_support/help_support_cubit.dart';
import '../../cubits/help_support/help_support_state.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF102A43),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<HelpSupportCubit, HelpSupportState>(
                builder: (context, state) {
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      _HeroBanner(controller: _animationController),
                      const SizedBox(height: 24),
                      
                      _AnimatedSection(
                        controller: _animationController,
                        delay: 0.06,
                        child: const _SearchBar(),
                      ),
                      const SizedBox(height: 24),
                      
                      if (!state.isSearchMode) ...[
                        _AnimatedSection(
                          controller: _animationController,
                          delay: 0.09,
                          child: const _ContactUsSection(),
                        ),
                        const SizedBox(height: 24),
                        
                        _AnimatedSection(
                          controller: _animationController,
                          delay: 0.12,
                          child: const _QuickLinksSection(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      
                      _AnimatedSection(
                        controller: _animationController,
                        delay: 0.15,
                        child: const _FaqSection(),
                      ),
                      const SizedBox(height: 24),
                      
                      if (!state.isSearchMode) ...[
                        _AnimatedSection(
                          controller: _animationController,
                          delay: 0.2,
                          child: const _FeedbackSection(),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          _InteractiveBackButton(),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontFamily: 'Newsreader',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'We\'re here to help',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InteractiveBackButton extends StatefulWidget {
  @override
  State<_InteractiveBackButton> createState() => _InteractiveBackButtonState();
}

class _InteractiveBackButtonState extends State<_InteractiveBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.pop();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final AnimationController controller;

  const _HeroBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    final dy = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0, dy.value),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A5F), Color(0xFF102A43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -4,
              right: -2,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.03),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Icon(LucideIcons.bookOpen, size: 20, color: const Color(0xFFC0C0C0).withValues(alpha: 0.8)),
                ),
                const Text(
                  'How can we help you today?',
                  style: TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Search our knowledge base or get in touch with our team directly.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 1.5,
                    color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _AnimatedSection({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final end = (delay + 0.4).clamp(0.0, 1.0);
    final opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );
    final dy = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: opacity.value,
          child: Transform.translate(
            offset: Offset(0, dy.value),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: _isFocused ? const Color(0xFFC0C0C0).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, size: 15, color: const Color(0xFFC0C0C0).withValues(alpha: 0.4)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: (val) => context.read<HelpSupportCubit>().updateSearchQuery(val),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search help articles…',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactUsSection extends StatelessWidget {
  const _ContactUsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Contact Us'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              const _ContactRow(
                icon: LucideIcons.messageCircle,
                title: 'Live Chat',
                subtitle: 'Average wait: 2 min',
                badgeText: 'Online',
                baseColor: Color(0xFF10B981), // emerald
                badgeColor: Color(0xFF6EE7B7), // emerald-300
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
              const _ContactRow(
                icon: LucideIcons.mail,
                title: 'Email Support',
                subtitle: 'support@rasseny.ai',
                badgeText: '24h',
                baseColor: Color(0xFFF59E0B), // amber
                badgeColor: Color(0xFFFCD34D), // amber-300
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
              const _ContactRow(
                icon: LucideIcons.atSign,
                title: 'Twitter / X',
                subtitle: '@RassenyAI',
                badgeText: 'Public',
                baseColor: Color(0xFF0EA5E9), // sky
                badgeColor: Color(0xFF7DD3FC), // sky-300
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color baseColor;
  final Color badgeColor;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.baseColor,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => UiFeedback.showSnack(
        context,
        'Opening $title…',
      ),
      borderRadius: BorderRadius.circular(24),
      splashColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: baseColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 18, color: baseColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: const Color(0xFFC0C0C0).withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: baseColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: baseColor.withValues(alpha: 0.25)),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10,
                  color: badgeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 14, color: const Color(0xFFC0C0C0).withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}

class _QuickLinksSection extends StatelessWidget {
  const _QuickLinksSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _QuickLinkCard(
            title: 'User Guide',
            icon: LucideIcons.bookOpen,
            color: Color(0xFFA78BFA),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _QuickLinkCard(
            title: 'What\'s New',
            icon: LucideIcons.zap,
            color: Color(0xFFF59E0B),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _QuickLinkCard(
            title: 'Status Page',
            icon: LucideIcons.externalLink,
            color: Color(0xFF34D399),
          ),
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _QuickLinkCard({required this.title, required this.icon, required this.color});

  @override
  State<_QuickLinkCard> createState() => _QuickLinkCardState();
}

class _QuickLinkCardState extends State<_QuickLinkCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(widget.icon, size: 16, color: widget.color),
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: const Color(0xFFC0C0C0).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          letterSpacing: 1.5,
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Getting Started':
        return const Color(0xFFF59E0B);
      case 'Fake Detection':
        return const Color(0xFF22D3EE);
      case 'Account & Billing':
        return const Color(0xFFA78BFA);
      case 'Content & Feed':
        return const Color(0xFF34D399);
      default:
        return const Color(0xFFC0C0C0);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Getting Started':
        return LucideIcons.zap;
      case 'Fake Detection':
        return LucideIcons.shield;
      case 'Account & Billing':
        return LucideIcons.creditCard;
      case 'Content & Feed':
        return LucideIcons.rss;
      default:
        return LucideIcons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpSupportCubit, HelpSupportState>(
      builder: (context, state) {
        final groups = state.groupFaqsByCategory;
        if (state.isSearchMode && groups.isEmpty) {
          return const _EmptyState();
        }

        return Column(
          children: groups.entries.map((entry) {
            final category = entry.key;
            final faqs = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 13,
                          color: _getCategoryColor(category),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        for (var i = 0; i < faqs.length; i++) ...[
                          _FaqItemWidget(
                            item: faqs[i],
                            isExpanded: state.expandedFaqIds.contains(faqs[i].id),
                            onTap: () => context.read<HelpSupportCubit>().toggleFaq(faqs[i].id),
                          ),
                          if (i < faqs.length - 1)
                            Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FaqItemWidget extends StatelessWidget {
  final FaqItem item;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqItemWidget({
    required this.item,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.white.withValues(alpha: 0.03),
      splashColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 14, color: const Color(0xFFC0C0C0).withValues(alpha: 0.3)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.question,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(LucideIcons.chevronDown, size: 16, color: const Color(0xFFC0C0C0).withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 48, right: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.answer,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: const Color(0xFFC0C0C0).withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Helpful?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const _FeedbackButton(icon: LucideIcons.thumbsUp),
                      const SizedBox(width: 8),
                      const _FeedbackButton(icon: LucideIcons.thumbsDown),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;

  const _FeedbackButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => UiFeedback.showSnack(context, 'Thanks for your feedback!'),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(icon, size: 11, color: const Color(0xFFC0C0C0).withValues(alpha: 0.5)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Icon(LucideIcons.search, size: 20, color: const Color(0xFFC0C0C0).withValues(alpha: 0.3)),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try different keywords',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: const Color(0xFFC0C0C0).withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpSupportCubit, HelpSupportState>(
      builder: (context, state) {
        final cubit = context.read<HelpSupportCubit>();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              const Text(
                'Rate your experience',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final isActive = index < state.feedbackRating;
                  return GestureDetector(
                    onTap: () => cubit.updateFeedbackRating(index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        LucideIcons.star,
                        size: 24,
                        color: isActive ? Colors.amber[400] : Colors.white.withValues(alpha: 0.1),
                        // Note: Using fill for active state might need custom SVG, but we use LucideIcons standard
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              if (state.feedbackRating > 0)
                Text(
                  _getRatingLabel(state.feedbackRating),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: const Color(0xFFC0C0C0).withValues(alpha: 0.5),
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                onChanged: cubit.updateFeedbackText,
                maxLines: 3,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tell us more about your experience...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.04),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: const Color(0xFFC0C0C0).withValues(alpha: 0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _SendFeedbackButton(
                  status: state.feedbackStatus,
                  isActive: state.feedbackRating > 0 && state.feedbackText.isNotEmpty,
                  onTap: cubit.submitFeedback,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}

class _SendFeedbackButton extends StatelessWidget {
  final FeedbackStatus status;
  final bool isActive;
  final VoidCallback onTap;

  const _SendFeedbackButton({
    required this.status,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (status == FeedbackStatus.success) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.thumbsUp, size: 16, color: Color(0xFF34D399)),
            SizedBox(width: 8),
            Text(
              'Thanks for your feedback!',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF34D399),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return TextButton(
      onPressed: (isActive && status == FeedbackStatus.idle) ? onTap : null,
      style: TextButton.styleFrom(
        backgroundColor: isActive ? const Color(0xFFC0C0C0) : Colors.white.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.06),
      ),
      child: status == FeedbackStatus.submitting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF102A43)),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.send,
                  size: 14,
                  color: isActive ? const Color(0xFF102A43) : const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                Text(
                  'Send Feedback',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: isActive ? const Color(0xFF102A43) : const Color(0xFFC0C0C0).withValues(alpha: 0.3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}


