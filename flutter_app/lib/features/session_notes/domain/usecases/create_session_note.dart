import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/core/usecases/usecase.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/repositories/session_note_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class CreateSessionNote implements UseCase<SessionNote, CreateSessionNoteParams> {
  final SessionNoteRepository repository;

  CreateSessionNote(this.repository);

  @override
  Future<Either<Failure, SessionNote>> call(CreateSessionNoteParams params) async {
    return await repository.createSessionNote(
      patientId: params.patientId,
      sessionDate: params.sessionDate,
      sessionStartTime: params.sessionStartTime,
      sessionDurationMinutes: params.sessionDurationMinutes,
      sessionType: params.sessionType,
      content: params.content,
    );
  }
}

class CreateSessionNoteParams {
  final String patientId;
  final DateTime sessionDate;
  final TimeOfDay sessionStartTime;
  final int sessionDurationMinutes;
  final SessionType sessionType;
  final String content;

  CreateSessionNoteParams({
    required this.patientId,
    required this.sessionDate,
    required this.sessionStartTime,
    required this.sessionDurationMinutes,
    required this.sessionType,
    required this.content,
  });
}
