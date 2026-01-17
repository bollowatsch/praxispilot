import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSessionNotesForPatient implements UseCase<List<SessionNote>, String> {
  final SessionNoteRepository repository;

  GetSessionNotesForPatient(this.repository);

  @override
  Future<Either<Failure, List<SessionNote>>> call(String patientId) async {
    return await repository.getSessionNotesForPatient(patientId);
  }
}
