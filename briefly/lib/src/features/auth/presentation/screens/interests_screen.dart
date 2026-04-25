import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../domain/repositories/auth_repository.dart';

import '../widgets/auth_header.dart';
import '../widgets/primary_button.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  static const List<String> _interests = [
    'Technology',
    'Business',
    'Science',
    'Health',
    'Sports',
    'Entertainment',
    'Politics',
    'World News',
    'Finance',
    'Education',
    'Travel',
    'Culture',
    'Environment',
    'AI & ML',
    'Startups',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleWidth(24)),
          child: Column(
            children: [
              SizedBox(height: context.scaleHeight(16)),

              const AuthHeader(
                title: 'Pick Your Interests',
                subtitle: 'Choose at least 3 topics to personalize your feed.',
              ),
              SizedBox(height: context.scaleHeight(32)),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: context.scaleWidth(10),
                    runSpacing: context.scaleHeight(10),
                    children: _interests.map((interest) {
                      final isSelected = _selected.contains(interest);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selected.remove(interest);
                          } else {
                            _selected.add(interest);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleWidth(20),
                            vertical: context.scaleHeight(12),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentBlue
                                : AppColors.silverGlass,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentBlue
                                  : AppColors.silverBorder,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: context.scaleFontSize(14),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.silverSecondaryLabel,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: context.scaleHeight(16)),
              PrimaryButton(
                label: 'Continue',
                isLoading: _isLoading,
                isDisabled: _selected.length < 3,
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    await context.read<AuthRepository>().saveInterests(
                      interests: _selected.toList(),
                    );
                    if (context.mounted) context.go(AppRouter.authSuccess);
                  } catch (e) {
                    if (context.mounted) {
                      AppDialogs.showError(
                        context,
                        message: 'Failed to save interests',
                      );
                    }
                  } finally {
                    if (context.mounted) setState(() => _isLoading = false);
                  }
                },
              ),
              SizedBox(height: context.scaleHeight(32)),
            ],
          ),
        ),
      ),
    );
  }
}
