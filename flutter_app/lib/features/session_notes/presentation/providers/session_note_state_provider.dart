import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/create_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/unlock_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/update_session_note.dart';
import 'package:PraxisPilot/features/session_notes/presentation/providers/session_note_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_note_state_provider.g.dart';

/// State for session note management
class SessionNoteState {
  final List<SessionNote> notes;
  final SessionNote? selectedNote;
  final bool isLoading;
  final String? errorMessage;
  final bool isSaving;

  const SessionNoteState({
    this.notes = const [],
    this.selectedNote,
    this.isLoading = false,
    this.errorMessage,
    this.isSaving = false,
  });

  SessionNoteState copyWith({
    List<SessionNote>? notes,
    SessionNote? selectedNote,
    bool? isLoading,
    String? errorMessage,
    bool? isSaving,
    bool clearSelectedNote = false,
    bool clearError = false,
  }) {
    return SessionNoteState(
      notes: notes ?? this.notes,
      selectedNote:
          clearSelectedNote ? null : (selectedNote ?? this.selectedNote),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// Session note state provider
@Riverpod(keepAlive: true)
class SessionNoteStateNotifier extends _$SessionNoteStateNotifier {
  @override
  SessionNoteState build() {
    return const SessionNoteState();
  }

  /// Load session notes for a specific patient
  Future<void> loadNotesForPatient(String patientId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref
        .read(getSessionNotesForPatientProvider)
        .call(patientId);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (notes) {
        state = state.copyWith(
          isLoading: false,
          notes: notes,
          clearError: true,
        );
      },
    );
  }

  /// Load a specific session note by ID
  Future<void> loadNoteById(String noteId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(getSessionNoteByIdProvider).call(noteId);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
      (note) {
        state = state.copyWith(
          isLoading: false,
          selectedNote: note,
          clearError: true,
        );
      },
    );
  }

  /// Select a note
  void selectNote(SessionNote? note) {
    state = state.copyWith(selectedNote: note, clearSelectedNote: note == null);
  }

  /// Create a new session note
  Future<bool> createNote(CreateSessionNoteParams params) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await ref.read(createSessionNoteProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isSaving: false,
          selectedNote: note,
          clearError: true,
        );
        // Reload notes for the patient
        loadNotesForPatient(params.patientId);
        return true;
      },
    );
  }

  /// Update an existing session note
  Future<bool> updateNote(UpdateSessionNoteParams params) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await ref.read(updateSessionNoteProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isSaving: false,
          selectedNote: note,
          clearError: true,
        );
        // Reload notes to reflect changes
        if (state.selectedNote != null) {
          loadNotesForPatient(note.patientId);
        }
        return true;
      },
    );
  }

  /// Finalize a session note
  Future<bool> finalizeNote(String noteId) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await ref.read(finalizeSessionNoteProvider).call(noteId);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isSaving: false,
          selectedNote: note,
          clearError: true,
        );
        // Reload notes to reflect changes
        loadNotesForPatient(note.patientId);
        return true;
      },
    );
  }

  /// Unlock a finalized session note
  Future<bool> unlockNote(String noteId, String reason) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final params = UnlockSessionNoteParams(
      noteId: noteId,
      unlockReason: reason,
    );

    final result = await ref.read(unlockSessionNoteProvider).call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isSaving: false,
          selectedNote: note,
          clearError: true,
        );
        // Reload notes to reflect changes
        loadNotesForPatient(note.patientId);
        return true;
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
