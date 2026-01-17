import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/session_notes/presentation/providers/session_note_state_provider.dart';
import 'package:PraxisPilot/features/session_notes/presentation/widgets/session_note_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionNotesListWidget extends ConsumerStatefulWidget {
  final String patientId;

  const SessionNotesListWidget({super.key, required this.patientId});

  @override
  ConsumerState<SessionNotesListWidget> createState() =>
      _SessionNotesListWidgetState();
}

class _SessionNotesListWidgetState
    extends ConsumerState<SessionNotesListWidget> {
  @override
  void initState() {
    super.initState();
    // Load notes when widget is first created
    Future.microtask(() {
      ref
          .read(sessionNoteStateProvider.notifier)
          .loadNotesForPatient(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionNoteStateProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.sessionNote_noNotes,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(sessionNoteStateProvider.notifier)
            .loadNotesForPatient(widget.patientId);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.notes.length,
        itemBuilder: (context, index) {
          final note = state.notes[index];
          return SessionNoteCard(
            note: note,
            onTap: () {
              context.pushNamed(
                'editSessionNote',
                pathParameters: {
                  'patientId': widget.patientId,
                  'noteId': note.id,
                },
              );
            },
          );
        },
      ),
    );
  }
}
