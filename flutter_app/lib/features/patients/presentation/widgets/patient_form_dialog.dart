import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/check_duplicates.dart';
import 'package:PraxisPilot/features/patients/domain/usecases/create_patient.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_providers.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  late final TextEditingController _insuranceInfoController;
  late final TextEditingController _emergencyContactNameController;
  late final TextEditingController _emergencyContactPhoneController;
  late final TextEditingController _emergencyContactRelationshipController;

  DateTime? _dateOfBirth;
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
    _insuranceInfoController = TextEditingController(
      text: patient?.insuranceInfo ?? '',
    );
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
    _insuranceInfoController.dispose();
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

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.person_add,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing ? 'Patient bearbeiten' : 'Neuer Patient',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Persönliche Informationen', context),
                      const SizedBox(height: 16),
                      _buildPersonalInfoSection(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Versicherungsinformation', context),
                      const SizedBox(height: 16),
                      _buildInsuranceSection(),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Notfallkontakt', context),
                      const SizedBox(height: 16),
                      _buildEmergencyContactSection(),
                    ],
                  ),
                ),
              ),
            ),

            // Footer buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Abbrechen'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _handleSubmit,
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Icon(Icons.check),
                    label: Text(isEditing ? 'Aktualisieren' : 'Erstellen'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Vorname *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vorname ist erforderlich';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nachname *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nachname ist erforderlich';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Geburtsdatum *',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.cake),
              errorText:
                  _dateOfBirth == null &&
                          _formKey.currentState?.validate() == false
                      ? 'Geburtsdatum ist erforderlich'
                      : null,
            ),
            child: Text(
              _dateOfBirth != null
                  ? DateFormat('dd.MM.yyyy').format(_dateOfBirth!)
                  : 'Datum auswählen',
              style: TextStyle(
                color: _dateOfBirth != null ? null : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-Mail',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
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
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Telefon',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Adresse',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.home),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return TextFormField(
      controller: _insuranceInfoController,
      decoration: const InputDecoration(
        labelText: 'Versicherungsinformation',
        hintText: 'z.B. Versicherungsnummer, Versicherungsname...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.medical_information),
      ),
      maxLines: 3,
    );
  }

  Widget _buildEmergencyContactSection() {
    return Column(
      children: [
        TextFormField(
          controller: _emergencyContactNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.contact_emergency),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyContactPhoneController,
          decoration: const InputDecoration(
            labelText: 'Telefon',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone_in_talk),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyContactRelationshipController,
          decoration: const InputDecoration(
            labelText: 'Beziehung',
            hintText: 'z.B. Ehepartner, Elternteil, Freund...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.people),
          ),
        ),
      ],
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

    // Check for duplicates before creating
    if (widget.patient == null) {
      final hasDuplicates = await _checkForDuplicates();
      if (hasDuplicates == true) {
        // User chose not to proceed
        return;
      }
    }

    setState(() => _isLoading = true);

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
      insuranceInfo:
          _insuranceInfoController.text.trim().isEmpty
              ? null
              : _insuranceInfoController.text.trim(),
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

    final success = await ref
        .read(patientStateProvider.notifier)
        .createPatient(params);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Patient ${_firstNameController.text} ${_lastNameController.text} wurde erfolgreich erstellt',
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
