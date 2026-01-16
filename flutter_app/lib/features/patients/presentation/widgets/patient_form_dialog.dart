import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/check_duplicates.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/create_patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/update_patient.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_providers.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum InsuranceType { statutory, private }

class PatientFormDialog extends ConsumerStatefulWidget {
  final Patient? patient; // null for creating new patient

  const PatientFormDialog({super.key, this.patient});

  @override
  ConsumerState<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends ConsumerState<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _insuranceNameController;
  late final TextEditingController _insuranceNumberController;
  late final TextEditingController _emergencyContactNameController;
  late final TextEditingController _emergencyContactPhoneController;
  late final TextEditingController _emergencyContactRelationshipController;

  String? _salutation;
  DateTime? _dateOfBirth;
  InsuranceType _insuranceType = InsuranceType.statutory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final patient = widget.patient;

    _firstNameController = TextEditingController(
      text: patient?.firstName ?? '',
    );
    _lastNameController = TextEditingController(text: patient?.lastName ?? '');
    _emailController = TextEditingController(text: patient?.email ?? '');
    _phoneController = TextEditingController(text: patient?.phone ?? '');
    _addressController = TextEditingController(text: patient?.address ?? '');

    // Parse insurance info if it exists
    final insuranceInfo = patient?.insuranceInfo ?? '';
    _insuranceNameController = TextEditingController(text: insuranceInfo);
    _insuranceNumberController = TextEditingController();

    _emergencyContactNameController = TextEditingController(
      text: patient?.emergencyContact?.name ?? '',
    );
    _emergencyContactPhoneController = TextEditingController(
      text: patient?.emergencyContact?.phone ?? '',
    );
    _emergencyContactRelationshipController = TextEditingController(
      text: patient?.emergencyContact?.relationship ?? '',
    );

    _dateOfBirth = patient?.dateOfBirth;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _insuranceNameController.dispose();
    _insuranceNumberController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _emergencyContactRelationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.patient != null;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? 'Patientendaten bearbeiten' : 'Neuer Patient',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 100, // Space for bottom bar
              ),
              children: [
                _buildPersonalDataSection(colorScheme),
                const SizedBox(height: 16),
                _buildContactSection(colorScheme),
                const SizedBox(height: 16),
                _buildEmergencyContactSection(colorScheme),
                const SizedBox(height: 16),
                _buildInsuranceSection(colorScheme),
              ],
            ),
          ),
          _buildBottomBar(context, colorScheme, isEditing),
        ],
      ),
    );
  }

  Widget _buildPersonalDataSection(ColorScheme colorScheme) {
    return _buildSection(
      title: 'PERSÖNLICHE DATEN',
      colorScheme: colorScheme,
      children: [
        _buildLabeledField(
          label: 'Anrede',
          child: DropdownButtonFormField<String>(
            value: _salutation,
            decoration: InputDecoration(
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Frau', child: Text('Frau')),
              DropdownMenuItem(value: 'Herr', child: Text('Herr')),
              DropdownMenuItem(value: 'Divers', child: Text('Divers')),
              DropdownMenuItem(value: null, child: Text('Keine Angabe')),
            ],
            onChanged: (value) => setState(() => _salutation = value),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Vorname',
          required: true,
          child: TextFormField(
            controller: _firstNameController,
            decoration: _inputDecoration(colorScheme, 'z.B. Maria'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vorname ist erforderlich';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Nachname',
          required: true,
          child: TextFormField(
            controller: _lastNameController,
            decoration: _inputDecoration(colorScheme, 'z.B. Mustermann'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nachname ist erforderlich';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Geburtsdatum',
          required: true,
          child: InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: _inputDecoration(colorScheme, null).copyWith(
                errorText:
                    _dateOfBirth == null &&
                            _formKey.currentState?.validate() == false
                        ? 'Geburtsdatum ist erforderlich'
                        : null,
              ),
              child: Text(
                _dateOfBirth != null
                    ? DateFormat('dd.MM.yyyy').format(_dateOfBirth!)
                    : 'TT.MM.JJJJ',
                style: TextStyle(
                  color:
                      _dateOfBirth != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ColorScheme colorScheme) {
    return _buildSection(
      title: 'KONTAKT',
      colorScheme: colorScheme,
      children: [
        _buildLabeledField(
          label: 'E-Mail',
          child: TextFormField(
            controller: _emailController,
            decoration: _inputDecoration(
              colorScheme,
              'email@beispiel.de',
            ).copyWith(
              prefixIcon: Icon(
                Icons.mail,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ungültige E-Mail-Adresse';
                }
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Telefonnummer',
          child: TextFormField(
            controller: _phoneController,
            decoration: _inputDecoration(
              colorScheme,
              '+49 123 456789',
            ).copyWith(
              prefixIcon: Icon(
                Icons.call,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection(ColorScheme colorScheme) {
    return _buildSection(
      title: 'NOTFALLKONTAKT',
      colorScheme: colorScheme,
      children: [
        _buildLabeledField(
          label: 'Name des Kontakts',
          child: TextFormField(
            controller: _emergencyContactNameController,
            decoration: _inputDecoration(colorScheme, 'Name'),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Beziehung',
          child: TextFormField(
            controller: _emergencyContactRelationshipController,
            decoration: _inputDecoration(colorScheme, 'z.B. Ehepartner'),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Telefonnummer',
          child: TextFormField(
            controller: _emergencyContactPhoneController,
            decoration: _inputDecoration(colorScheme, '+49...'),
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceSection(ColorScheme colorScheme) {
    return _buildSection(
      title: 'VERSICHERUNG',
      colorScheme: colorScheme,
      children: [
        // Insurance type toggle
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildInsuranceTypeButton(
                  label: 'Gesetzlich',
                  isSelected: _insuranceType == InsuranceType.statutory,
                  onTap:
                      () => setState(
                        () => _insuranceType = InsuranceType.statutory,
                      ),
                  colorScheme: colorScheme,
                ),
              ),
              Expanded(
                child: _buildInsuranceTypeButton(
                  label: 'Privat',
                  isSelected: _insuranceType == InsuranceType.private,
                  onTap:
                      () => setState(
                        () => _insuranceType = InsuranceType.private,
                      ),
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Krankenkasse',
          child: TextFormField(
            controller: _insuranceNameController,
            decoration: _inputDecoration(colorScheme, 'z.B. TK, AOK...'),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabeledField(
          label: 'Versichertennummer',
          child: TextFormField(
            controller: _insuranceNumberController,
            decoration: _inputDecoration(colorScheme, 'Z123456789'),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required ColorScheme colorScheme,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required Widget child,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            required ? '$label *' : label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildInsuranceTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                isSelected
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
    bool isEditing,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Abbrechen',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        )
                        : Text(
                          isEditing ? 'Speichern' : 'Erstellen',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ColorScheme colorScheme, String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('de'),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte wählen Sie ein Geburtsdatum aus'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isEditing = widget.patient != null;

    // Check for duplicates before creating (not needed when editing)
    if (!isEditing) {
      final hasDuplicates = await _checkForDuplicates();
      if (hasDuplicates == true) {
        // User chose not to proceed
        return;
      }
    }

    setState(() => _isLoading = true);

    // Combine insurance info
    final insuranceInfo =
        _insuranceNameController.text.trim().isEmpty &&
                _insuranceNumberController.text.trim().isEmpty
            ? null
            : '${_insuranceType == InsuranceType.statutory ? 'GKV' : 'PKV'}: '
                    '${_insuranceNameController.text.trim()} '
                    '(${_insuranceNumberController.text.trim()})'
                .trim();

    final bool success;

    if (isEditing) {
      // Update existing patient
      final params = UpdatePatientParams(
        patientId: widget.patient!.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        email:
            _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
        phone:
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
        address:
            _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
        insuranceInfo: insuranceInfo,
        emergencyContactName:
            _emergencyContactNameController.text.trim().isEmpty
                ? null
                : _emergencyContactNameController.text.trim(),
        emergencyContactPhone:
            _emergencyContactPhoneController.text.trim().isEmpty
                ? null
                : _emergencyContactPhoneController.text.trim(),
        emergencyContactRelationship:
            _emergencyContactRelationshipController.text.trim().isEmpty
                ? null
                : _emergencyContactRelationshipController.text.trim(),
      );

      success = await ref
          .read(patientStateProvider.notifier)
          .updatePatient(params);
    } else {
      // Create new patient
      final params = CreatePatientParams(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dateOfBirth!,
        email:
            _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
        phone:
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
        address:
            _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
        insuranceInfo: insuranceInfo,
        emergencyContactName:
            _emergencyContactNameController.text.trim().isEmpty
                ? null
                : _emergencyContactNameController.text.trim(),
        emergencyContactPhone:
            _emergencyContactPhoneController.text.trim().isEmpty
                ? null
                : _emergencyContactPhoneController.text.trim(),
        emergencyContactRelationship:
            _emergencyContactRelationshipController.text.trim().isEmpty
                ? null
                : _emergencyContactRelationshipController.text.trim(),
      );

      success = await ref
          .read(patientStateProvider.notifier)
          .createPatient(params);
    }

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Patient ${_firstNameController.text} ${_lastNameController.text} wurde erfolgreich aktualisiert'
                : 'Patient ${_firstNameController.text} ${_lastNameController.text} wurde erfolgreich erstellt',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final error = ref.read(patientStateProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: ${error ?? "Unbekannter Fehler"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Check for duplicate patients and show warning dialog
  /// Returns true if user cancels, false if user proceeds
  Future<bool?> _checkForDuplicates() async {
    final params = CheckDuplicatesParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _dateOfBirth!,
    );

    final result = await ref.read(checkDuplicatesProvider).call(params);

    return result.fold(
      (failure) {
        // Error checking duplicates - proceed anyway
        return false;
      },
      (duplicates) async {
        if (duplicates.isEmpty) {
          // No duplicates - proceed
          return false;
        }

        // Show warning dialog
        final shouldProceed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                icon: const Icon(Icons.warning, color: Colors.orange, size: 48),
                title: const Text('Mögliche Duplikate gefunden'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Es wurden bereits Patienten mit ähnlichen Daten gefunden:',
                    ),
                    const SizedBox(height: 16),
                    ...duplicates.map(
                      (p) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '• ${p.fullName} (${p.age} Jahre)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Möchten Sie trotzdem fortfahren?'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Abbrechen'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Trotzdem erstellen'),
                  ),
                ],
              ),
        );

        // Return true if user cancelled (null or false)
        return shouldProceed != true;
      },
    );
  }
}
