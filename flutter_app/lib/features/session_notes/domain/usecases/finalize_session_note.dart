import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:fpdart/fpdart.dart';

class FinalizeSessionNote implements UseCase<SessionNote, String> {
  final SessionNoteRepository repository;

  FinalizeSessionNote(this.repository);

  @override
  Future<Either<Failure, SessionNote>> call(String noteId) async {
    return await repository.finalizeSessionNote(noteId);
  }
}
