import 'package:PraxisPilot/config/themes/app_theme.dart';
import 'package:PraxisPilot/features/onboarding/domain/entities/practice_info.dart';
import 'package:PraxisPilot/features/onboarding/presentation/providers/onboarding_providers.dart';
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
  String? _practiceType;
  final _addressSearchController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _practiceNameController.dispose();
    _addressSearchController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Praxisinformationen',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 512),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Progress Indicator
                      _buildProgressIndicator(context),
                      const SizedBox(height: 32),
                      // Headline
                      Text(
                        'Praxisdetails eingeben',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bitte vervollständigen Sie die Basisdaten Ihrer Praxis für die Einrichtung von PraxisPilot.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Practice Name
                            _buildTextField(
                              controller: _practiceNameController,
                              label: 'Praxisname (Pflichtfeld)',
                              placeholder: 'z.B. Psychologische Praxis am Park',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Pflichtfeld';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Practice Type
                            _buildDropdownField(
                              label: 'Praxistyp',
                              hint: 'Bitte wählen',
                              value: _practiceType,
                              items: const [
                                'Einzelpraxis',
                                'Gemeinschaftspraxis',
                                'MVZ / Therapiezentrum',
                              ],
                              onChanged: (value) {
                                setState(() => _practiceType = value);
                              },
                            ),
                            const SizedBox(height: 32),
                            // Location Section
                            Text(
                              'STANDORT',
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Address Search
                            TextFormField(
                              controller: _addressSearchController,
                              decoration: InputDecoration(
                                hintText: 'Adresse suchen...',
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: context.colorScheme.primary,
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: context.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                ),
                                filled: true,
                                fillColor: context.colorScheme.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: context.colorScheme.primary
                                        .withValues(alpha: 0.2),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: context.colorScheme.primary
                                        .withValues(alpha: 0.2),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: context.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Info Box
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: context.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                                border: Border.all(
                                  color: context.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: context.colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Straßennamen, PLZ und Ort werden automatisch erkannt und für Ihre Rechnungsdaten übernommen.',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Contact Section
                            Text(
                              'KONTAKT & ONLINE',
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _phoneController,
                              placeholder: 'Telefonnummer',
                              icon: Icons.call,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _emailController,
                              placeholder: 'E-Mail Adresse',
                              icon: Icons.mail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: _websiteController,
                              placeholder: 'Webseite (www.)',
                              icon: Icons.language,
                              keyboardType: TextInputType.url,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Fixed Footer
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withValues(alpha: 0.9),
          border: Border(
            top: BorderSide(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.colorScheme.primary,
                            side: BorderSide(
                              color: context.colorScheme.primary,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Zurück',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Weiter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'ONBOARDING',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Schritt 2 von 3',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.666,
            minHeight: 8,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? label,
    required String placeholder,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon:
                icon != null
                    ? Icon(
                      icon,
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.4,
                      ),
                    )
                    : null,
            filled: true,
            fillColor: context.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.colorScheme.error),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: icon != null ? 12 : 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    String? label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          hint: Text(hint),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final practiceInfo = PracticeInfo(
      practiceName: _practiceNameController.text.trim(),
      practiceType: _practiceType ?? '',
      street: '', // Will be parsed from address search
      houseNumber: '',
      postalCode: '',
      city: '',
      state: '',
      country: '',
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
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
