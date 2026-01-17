import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteSessionNote implements UseCase<Unit, String> {
  final SessionNoteRepository repository;

  DeleteSessionNote(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String noteId) async {
    return await repository.deleteSessionNote(noteId);
  }
}
