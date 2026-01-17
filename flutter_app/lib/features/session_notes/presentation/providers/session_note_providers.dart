import 'package:PraxisPilot/core/providers/supabase_provider.dart';
import 'package:PraxisPilot/features/session_notes/data/datasources/session_note_remote_datasource.dart';
import 'package:PraxisPilot/features/session_notes/data/repositories/session_note_repository_impl.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/create_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/delete_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/finalize_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/get_session_note_by_id.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/get_session_note_history.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/get_session_notes_for_patient.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/unlock_session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/usecases/update_session_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_note_providers.g.dart';

@riverpod
SessionNoteRemoteDataSource sessionNoteRemoteDataSource(Ref ref) {
  return SessionNoteRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
SessionNoteRepository sessionNoteRepository(Ref ref) {
  return SessionNoteRepositoryImpl(
      ref.watch(sessionNoteRemoteDataSourceProvider));
}

// Use cases
@riverpod
CreateSessionNote createSessionNote(Ref ref) {
  return CreateSessionNote(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
GetSessionNotesForPatient getSessionNotesForPatient(Ref ref) {
  return GetSessionNotesForPatient(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
GetSessionNoteById getSessionNoteById(Ref ref) {
  return GetSessionNoteById(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
UpdateSessionNote updateSessionNote(Ref ref) {
  return UpdateSessionNote(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
DeleteSessionNote deleteSessionNote(Ref ref) {
  return DeleteSessionNote(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
FinalizeSessionNote finalizeSessionNote(Ref ref) {
  return FinalizeSessionNote(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
UnlockSessionNote unlockSessionNote(Ref ref) {
  return UnlockSessionNote(ref.watch(sessionNoteRepositoryProvider));
}

@riverpod
GetSessionNoteHistory getSessionNoteHistory(Ref ref) {
  return GetSessionNoteHistory(ref.watch(sessionNoteRepositoryProvider));
}
