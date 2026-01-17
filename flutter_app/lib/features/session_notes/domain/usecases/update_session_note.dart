import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class UpdateSessionNote implements UseCase<SessionNote, UpdateSessionNoteParams> {
  final SessionNoteRepository repository;

  UpdateSessionNote(this.repository);

  @override
  Future<Either<Failure, SessionNote>> call(UpdateSessionNoteParams params) async {
    return await repository.updateSessionNote(
      noteId: params.noteId,
      sessionDate: params.sessionDate,
      sessionStartTime: params.sessionStartTime,
      sessionDurationMinutes: params.sessionDurationMinutes,
      sessionType: params.sessionType,
      content: params.content,
      status: params.status,
    );
  }
}

class UpdateSessionNoteParams {
  final String noteId;
  final DateTime? sessionDate;
  final TimeOfDay? sessionStartTime;
  final int? sessionDurationMinutes;
  final SessionType? sessionType;
  final String? content;
  final NoteStatus? status;

  UpdateSessionNoteParams({
    required this.noteId,
    this.sessionDate,
    this.sessionStartTime,
    this.sessionDurationMinutes,
    this.sessionType,
    this.content,
    this.status,
  });
}
