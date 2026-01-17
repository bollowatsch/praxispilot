import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionNoteCard extends StatelessWidget {
  final SessionNote note;
  final VoidCallback onTap;

  const SessionNoteCard({super.key, required this.note, required this.onTap});

  String _getSessionTypeLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (note.sessionType) {
      case SessionType.individual:
        return l10n.sessionNote_typeIndividual;
      case SessionType.group:
        return l10n.sessionNote_typeGroup;
      case SessionType.family:
        return l10n.sessionNote_typeFamily;
      case SessionType.couples:
        return l10n.sessionNote_typeCouples;
      case SessionType.other:
        return l10n.sessionNote_typeOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.yMMMd().format(note.sessionDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      note.isDraft
                          ? l10n.sessionNote_draft
                          : l10n.sessionNote_finalized,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor:
                        note.isDraft
                            ? theme.colorScheme.secondaryContainer
                            : theme.colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${note.sessionStartTime.format(context)} • ${note.sessionDurationMinutes} min',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.category,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSessionTypeLabel(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
