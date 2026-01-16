import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientsPage extends ConsumerStatefulWidget {
  const PatientsPage({super.key});

  @override
  ConsumerState<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends ConsumerState<PatientsPage> {
  final _searchController = TextEditingController();
  PatientStatus? _statusFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(patientStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patienten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(patientStateProvider.notifier).loadPatients();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(context, colorScheme),
          Expanded(child: _buildPatientList(context, state, colorScheme)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open add patient dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient form dialog - coming soon')),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Neuer Patient'),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Patient suchen (Name, Email)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(patientStateProvider.notifier)
                              .setSearchQuery(null);
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // Debounce search
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_searchController.text == value) {
                  ref
                      .read(patientStateProvider.notifier)
                      .setSearchQuery(value.isEmpty ? null : value);
                }
              });
            },
          ),
          const SizedBox(height: 12),
          // Status filter chips
          Row(
            children: [
              const Text(
                'Status: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Alle'),
                selected: _statusFilter == null,
                onSelected: (selected) {
                  setState(() => _statusFilter = null);
                  ref.read(patientStateProvider.notifier).setStatusFilter(null);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Aktiv'),
                selected: _statusFilter == PatientStatus.active,
                onSelected: (selected) {
                  setState(
                    () =>
                        _statusFilter = selected ? PatientStatus.active : null,
                  );
                  ref
                      .read(patientStateProvider.notifier)
                      .setStatusFilter(_statusFilter);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Archiviert'),
                selected: _statusFilter == PatientStatus.archived,
                onSelected: (selected) {
                  setState(
                    () =>
                        _statusFilter =
                            selected ? PatientStatus.archived : null,
                  );
                  ref
                      .read(patientStateProvider.notifier)
                      .setStatusFilter(_statusFilter);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList(
    BuildContext context,
    PatientState state,
    ColorScheme colorScheme,
  ) {
    if (state.isLoading && state.patients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Fehler beim Laden der Patienten',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(patientStateProvider.notifier).loadPatients();
              },
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    if (state.patients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Keine Patienten gefunden',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Fügen Sie einen neuen Patienten hinzu',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.patients.length,
      itemBuilder: (context, index) {
        final patient = state.patients[index];
        return _buildPatientCard(context, patient, colorScheme);
      },
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    Patient patient,
    ColorScheme colorScheme,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            patient.firstName[0].toUpperCase() +
                patient.lastName[0].toUpperCase(),
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          patient.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${patient.age} Jahre'),
            if (patient.email != null) Text(patient.email!),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (patient.isArchived)
              Chip(
                label: const Text('Archiviert'),
                backgroundColor: colorScheme.errorContainer,
                labelStyle: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontSize: 12,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {
                // TODO: Navigate to patient detail
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Patient detail for ${patient.fullName}'),
                  ),
                );
              },
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          // TODO: Navigate to patient detail
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected ${patient.fullName}')),
          );
        },
      ),
    );
  }
}
