import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/practice_info.dart';
import 'package:PraxisPilot/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:PraxisPilot/shared/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingCommercialInfoPage extends ConsumerStatefulWidget {
  const OnboardingCommercialInfoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingCommercialInfoPageState();
}

class _OnboardingCommercialInfoPageState
    extends ConsumerState<OnboardingCommercialInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _practiceNameController = TextEditingController();
  final _practiceTypeController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNrController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _webSiteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _practiceNameController.dispose();
    _practiceTypeController.dispose();
    _streetController.dispose();
    _houseNrController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _webSiteController.dispose();
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
              context.l10n.commercialInfo_title,
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          controller: _practiceNameController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_practiceName,
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
                    spacing: 15,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_street,
                          ),
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _houseNrController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_houseNr,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 15,
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_city,
                          ),
                        ),
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            labelText: context.l10n.dummy_state,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(
                      labelText: context.l10n.dummy_country,
                    ),
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
            SizedBox(height: 10),
            TextFormField(
              controller: _webSiteController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.home_outlined),
                labelText: context.l10n.dummy_url,
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                  spacing: 15,
                  children: [
                    Flexible(
                      child: PrimaryButton(
                        label: '',
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Flexible(
                      child: PrimaryButton(
                        label: '',
                        icon: Icons.arrow_forward,
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
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

    final practiceInfo = PracticeInfo(
      practiceName: _practiceNameController.text.trim(),
      practiceType: _practiceTypeController.text.trim(),
      street: _streetController.text.trim(),
      houseNumber: _houseNrController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      website: _webSiteController.text.trim(),
    );

    final result = await ref
        .read(setPracticeInfoProvider)
        .call(practiceInfo: practiceInfo);

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
        context.pushNamed('onboardingPreferences');
      },
    );
  }
}
