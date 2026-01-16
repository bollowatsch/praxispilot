import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/personal_info.dart';
import 'package:PraxisPilot/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:PraxisPilot/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingPersonalInfoPage extends ConsumerStatefulWidget {
  const OnboardingPersonalInfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingPersonalInfoPageState();
}

class _OnboardingPersonalInfoPageState
    extends ConsumerState<OnboardingPersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titlePrefixController = TextEditingController();
  final _titleSuffixController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleSuffixController.dispose();
    _titlePrefixController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.l10n.personalInfo_title,
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          controller: _titlePrefixController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_titlePrefix,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_firstName,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.l10n.form_error_required;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_lastName,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.l10n.form_error_required;
                            }
                            return null;
                          },
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          controller: _titleSuffixController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_titleSuffix,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                labelText: context.l10n.dummy_email,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined),
                labelText: context.l10n.dummy_phone,
              ),
            ),
            SizedBox(height: 15),

            _isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
                    label: '',
                    icon: Icons.arrow_forward,
                    onPressed: _handleSubmit,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final personalInfo = PersonalInfo(
      titlePrefix: _titlePrefixController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      titleSuffix: _titleSuffixController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final result = await ref.read(setPersonalInfoProvider).call(
      personalInfo: personalInfo,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: context.colorScheme.error,
          ),
        );
      },
      (_) {
        context.pushNamed('onboardingCommercialInfo');
      },
    );
  }
}
