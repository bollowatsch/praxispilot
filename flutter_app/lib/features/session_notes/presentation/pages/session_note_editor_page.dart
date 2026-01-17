import 'package:PraxisPilot/core/l10n/l10n_extension.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/create_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/update_session_note.dart';
import 'package:PraxisPilot/features/session_notes/presentation/providers/session_note_state_provider.dart';
import 'package:PraxisPilot/features/session_notes/presentation/widgets/unlock_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SessionNoteEditorPage extends ConsumerStatefulWidget {
  final String patientId;
  final String? noteId;

  const SessionNoteEditorPage({
    super.key,
    required this.patientId,
    this.noteId,
  });

  @override
  ConsumerState<SessionNoteEditorPage> createState() =>
      _SessionNoteEditorPageState();
}

class _SessionNoteEditorPageState extends ConsumerState<SessionNoteEditorPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  DateTime _sessionDate = DateTime.now();
  TimeOfDay _sessionStartTime = TimeOfDay.now();
  int _sessionDurationMinutes = 50;
  SessionType _sessionType = SessionType.individual;
  NoteStatus _status = NoteStatus.draft;

  bool _isLoading = true;
  bool _hasUnsavedChanges = false;
  SessionNote? _currentNote;

  @override
  void initState() {
    super.initState();
    // Delay provider modification until after widget tree is built
    Future.microtask(() => _loadNote());
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      await ref
          .read(sessionNoteStateProvider.notifier)
          .loadNoteById(widget.noteId!);

      final note = ref.read(sessionNoteStateProvider).selectedNote;
      if (note != null && mounted) {
        setState(() {
          _currentNote = note;
          _sessionDate = note.sessionDate;
          _sessionStartTime = note.sessionStartTime;
          _sessionDurationMinutes = note.sessionDurationMinutes;
          _sessionType = note.sessionType;
          _status = note.status;
          _contentController.text = note.content;
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.noteId != null;
  bool get _isFinalized => _currentNote?.isFinalized ?? false;
  bool get _canEdit => !_isFinalized || (_currentNote?.wasUnlocked ?? false);

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _sessionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _sessionDate = date;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _sessionStartTime,
    );
    if (time != null) {
      setState(() {
        _sessionStartTime = time;
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(sessionNoteStateProvider.notifier);
    bool success;

    if (_isEditing) {
      success = await notifier.updateNote(
        UpdateSessionNoteParams(
          noteId: widget.noteId!,
          sessionDate: _sessionDate,
          sessionStartTime: _sessionStartTime,
          sessionDurationMinutes: _sessionDurationMinutes,
          sessionType: _sessionType,
          content: _contentController.text.trim(),
          status: _status,
        ),
      );
    } else {
      success = await notifier.createNote(
        CreateSessionNoteParams(
          patientId: widget.patientId,
          sessionDate: _sessionDate,
          sessionStartTime: _sessionStartTime,
          sessionDurationMinutes: _sessionDurationMinutes,
          sessionType: _sessionType,
          content: _contentController.text.trim(),
        ),
      );
    }

    if (success && mounted) {
      setState(() => _hasUnsavedChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.sessionNote_saveSuccess)),
      );
      if (!_isEditing) {
        context.pop();
      } else {
        _loadNote();
        context.pop();
      }
    }
  }

  Future<void> _toggleStatus() async {
    if (_status == NoteStatus.draft && _isEditing) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(context.l10n.sessionNote_finalize),
              content: Text(
                'Are you sure you want to finalize this note? Finalized notes can only be edited after unlocking.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.sessionNote_cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.sessionNote_finalize),
                ),
              ],
            ),
      );

      if (confirmed == true) {
        final success = await ref
            .read(sessionNoteStateProvider.notifier)
            .finalizeNote(widget.noteId!);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.sessionNote_finalizeSuccess)),
          );
          _loadNote();
        }
      }
    }
  }

  Future<void> _unlockNote() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => const UnlockNoteDialog(),
    );

    if (reason != null) {
      final success = await ref
          .read(sessionNoteStateProvider.notifier)
          .unlockNote(widget.noteId!, reason);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.sessionNote_unlockSuccess)),
        );
        _loadNote();
      }
    }
  }

  String _getSessionTypeLabel(SessionType type) {
    final l10n = context.l10n;
    switch (type) {
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
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final state = ref.watch(sessionNoteStateProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.sessionNote_title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(l10n.sessionNote_unsavedChanges),
                  content: Text(l10n.sessionNote_unsavedChangesMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.sessionNote_cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.sessionNote_discard),
                    ),
                  ],
                ),
          );
          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.sessionNote_title)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Metadata Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.sessionNote_date,
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: _canEdit ? _selectDate : null,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat.yMMMd().format(
                                            _sessionDate,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.sessionNote_startTime,
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: _canEdit ? _selectTime : null,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(_sessionStartTime.format(context)),
                                        const Icon(Icons.access_time, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<SessionType>(
                              value: _sessionType,
                              decoration: InputDecoration(
                                labelText: l10n.sessionNote_type,
                                border: const OutlineInputBorder(),
                              ),
                              items:
                                  SessionType.values.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(_getSessionTypeLabel(type)),
                                    );
                                  }).toList(),
                              onChanged:
                                  _canEdit
                                      ? (value) {
                                        if (value != null) {
                                          setState(() {
                                            _sessionType = value;
                                            _hasUnsavedChanges = true;
                                          });
                                        }
                                      }
                                      : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: _sessionDurationMinutes.toString(),
                              decoration: InputDecoration(
                                labelText: l10n.sessionNote_duration,
                                border: const OutlineInputBorder(),
                                suffixText: 'min',
                              ),
                              keyboardType: TextInputType.number,
                              enabled: _canEdit,
                              onChanged: (value) {
                                final minutes = int.tryParse(value);
                                if (minutes != null) {
                                  setState(() {
                                    _sessionDurationMinutes = minutes;
                                    _hasUnsavedChanges = true;
                                  });
                                }
                              },
                              validator: (value) {
                                final minutes = int.tryParse(value ?? '');
                                if (minutes == null || minutes <= 0) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Content Section
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: l10n.sessionNote_content,
                  hintText: l10n.sessionNote_content,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                enabled: _canEdit,
                onChanged: (_) => setState(() => _hasUnsavedChanges = true),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (_isEditing) ...[
                  IconButton.filled(
                    onPressed:
                        _status == NoteStatus.draft
                            ? _toggleStatus
                            : (_canEdit ? null : _unlockNote),
                    icon: Icon(
                      _status == NoteStatus.draft
                          ? Icons.lock_open
                          : Icons.lock,
                    ),
                    tooltip:
                        _status == NoteStatus.draft
                            ? l10n.sessionNote_finalize
                            : l10n.sessionNote_unlock,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _status == NoteStatus.draft
                        ? l10n.sessionNote_draft
                        : l10n.sessionNote_finalized,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _canEdit && !state.isSaving ? _save : null,
                    icon:
                        state.isSaving
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.save),
                    label: Text(l10n.sessionNote_save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
