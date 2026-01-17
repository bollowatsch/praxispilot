import 'package:PraxisPilot/core/errors/failures.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note.dart';
import 'package:PraxisPilot/features/session_notes/domain/entities/session_note_history.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

/// Repository interface for session note operations
abstract class SessionNoteRepository {
  /// Create a new session note
  Future<Either<Failure, SessionNote>> createSessionNote({
    required String patientId,
    required DateTime sessionDate,
    required TimeOfDay sessionStartTime,
    required int sessionDurationMinutes,
    required SessionType sessionType,
    required String content,
  });

  /// Get all session notes for a specific patient
  Future<Either<Failure, List<SessionNote>>> getSessionNotesForPatient(
    String patientId,
  );

  /// Get a specific session note by ID
  Future<Either<Failure, SessionNote>> getSessionNoteById(String noteId);

  /// Update an existing session note
  Future<Either<Failure, SessionNote>> updateSessionNote({
    required String noteId,
    DateTime? sessionDate,
    TimeOfDay? sessionStartTime,
    int? sessionDurationMinutes,
    SessionType? sessionType,
    String? content,
    NoteStatus? status,
  });

  /// Delete a session note (soft delete)
  Future<Either<Failure, Unit>> deleteSessionNote(String noteId);

  /// Finalize a session note (change status to finalized)
  Future<Either<Failure, SessionNote>> finalizeSessionNote(String noteId);

  /// Unlock a finalized session note for editing
  Future<Either<Failure, SessionNote>> unlockSessionNote({
    required String noteId,
    required String unlockReason,
  });

  /// Get version history for a specific session note
  Future<Either<Failure, List<SessionNoteHistory>>> getSessionNoteHistory(
    String noteId,
  );
}
