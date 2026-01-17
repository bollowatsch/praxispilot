import 'package:PraxisPilot/features/patients/domain/entities/patient.dart';
import 'package:PraxisPilot/features/patients/presentation/providers/patient_state_provider.dart';
import 'package:PraxisPilot/features/session_notes/presentation/widgets/session_notes_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PatientDetailPage extends ConsumerStatefulWidget {
  final String patientId;

  const PatientDetailPage({required this.patientId, super.key});

  @override
  ConsumerState<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends ConsumerState<PatientDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Patient? _patient;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPatient();
  }

  void _loadPatient() {
    final patients = ref.read(patientStateProvider).patients;
    _patient = patients.firstWhere((p) => p.id == widget.patientId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Reload patient data if state changes
    ref.listen(patientStateProvider, (_, __) {
      _loadPatient();
      setState(() {});
    });

    if (_patient == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Patient nicht gefunden')),
        body: const Center(child: Text('Patient wurde nicht gefunden')),
      );
    }

    final patient = _patient!;
    final initials =
        '${patient.firstName[0].toUpperCase()}${patient.lastName[0].toUpperCase()}';

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppBar(context, patient, colorScheme),
            _buildProfileHeader(context, patient, initials, colorScheme),
            _buildTabs(context, colorScheme),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(context, patient, colorScheme),
            _buildSessionNotesTab(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(
            'newSessionNote',
            pathParameters: {'patientId': widget.patientId},
          );
        },
        icon: Icon(Icons.edit_note),
        label: Text('Neue Sitzungsnotiz'),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    Patient patient,
    ColorScheme colorScheme,
  ) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => context.pop(),
      ),
      title: Column(
        children: [
          Text(
            patient.fullName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  child: const Text('Patient archivieren'),
                  onTap: () {
                    // TODO: Archive patient
                  },
                ),
                PopupMenuItem(
                  child: const Text('Patient löschen'),
                  onTap: () {
                    // TODO: Delete patient
                  },
                ),
              ],
        ),
      ],
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    Patient patient,
    String initials,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 4),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              patient.fullName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${patient.age} Jahre • Geb. ${DateFormat('d. MMMM yyyy', 'de').format(patient.dateOfBirth)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: Text(
                    patient.isActive ? 'AKTIV' : 'INAKTIV',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  backgroundColor:
                      patient.isActive
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.error.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color:
                        patient.isActive
                            ? colorScheme.primary
                            : colorScheme.error,
                  ),
                ),
                const SizedBox(width: 8),
                if (patient.insuranceInfo != null)
                  Chip(
                    label: const Text(
                      'GKV',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    labelStyle: const TextStyle(color: Colors.blue),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, ColorScheme colorScheme) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 3,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          tabs: const [Tab(text: 'PROFIL'), Tab(text: 'SITZUNGSPROTOKOLLE')],
        ),
      ),
    );
  }

  Widget _buildProfileTab(
    BuildContext context,
    Patient patient,
    ColorScheme colorScheme,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          'PERSONALIEN',
          [
            _buildInfoTile(
              context,
              Icons.calendar_today,
              'Geburtsdatum',
              DateFormat('d. MMMM yyyy', 'de').format(patient.dateOfBirth),
              colorScheme,
            ),
            if (patient.address != null)
              _buildInfoTile(
                context,
                Icons.location_on,
                'Anschrift',
                patient.address!,
                colorScheme,
              ),
            if (patient.phone != null)
              _buildInfoTile(
                context,
                Icons.call,
                'Telefon',
                patient.phone!,
                colorScheme,
              ),
            if (patient.email != null)
              _buildInfoTile(
                context,
                Icons.email,
                'E-Mail',
                patient.email!,
                colorScheme,
              ),
          ],
          onEdit: () => _editPatient(context),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 24),
        if (patient.emergencyContact != null)
          _buildSection(context, 'NOTFALLKONTAKT', [
            _buildEmergencyContactTile(
              context,
              patient.emergencyContact!.name,
              patient.emergencyContact!.relationship ?? 'Kontakt',
              patient.emergencyContact!.phone,
              colorScheme,
            ),
          ], colorScheme: colorScheme),
        const SizedBox(height: 24),
        if (patient.insuranceInfo != null)
          _buildSection(context, 'VERSICHERUNG', [
            _buildInsuranceTile(context, patient.insuranceInfo!, colorScheme),
          ], colorScheme: colorScheme),
      ],
    );
  }

  Widget _buildSessionNotesTab(BuildContext context) {
    return SessionNotesListWidget(patientId: widget.patientId);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children, {
    VoidCallback? onEdit,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              if (onEdit != null)
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, size: 16, color: colorScheme.primary),
                  label: Text(
                    'Bearbeiten',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactTile(
    BuildContext context,
    String name,
    String relationship,
    String phone,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.contact_emergency,
          size: 20,
          color: Colors.orange,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        '$relationship • $phone',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildInsuranceTile(
    BuildContext context,
    String insuranceInfo,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KRANKENKASSE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insuranceInfo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AKTIV',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _editPatient(BuildContext context) async {
    final result = await context.pushNamed<bool>(
      'editPatient',
      pathParameters: {'id': _patient!.id},
      extra: _patient,
    );

    if (result == true && mounted) {
      ref.read(patientStateProvider.notifier).loadPatients();
    }
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
