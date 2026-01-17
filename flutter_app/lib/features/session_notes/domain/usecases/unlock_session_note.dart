import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:fpdart/fpdart.dart';

class UnlockSessionNote implements UseCase<SessionNote, UnlockSessionNoteParams> {
  final SessionNoteRepository repository;

  UnlockSessionNote(this.repository);

  @override
  Future<Either<Failure, SessionNote>> call(UnlockSessionNoteParams params) async {
    return await repository.unlockSessionNote(
      noteId: params.noteId,
      unlockReason: params.unlockReason,
    );
  }
}

class UnlockSessionNoteParams {
  final String noteId;
  final String unlockReason;

  UnlockSessionNoteParams({
    required this.noteId,
    required this.unlockReason,
  });
}
