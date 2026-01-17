import 'package:flutter/material.dart';

/// Represents the type of therapy session
enum SessionType {
  individual('individual'),
  group('group'),
  family('family'),
  couples('couples'),
  other('other');

  const SessionType(this.value);
  final String value;

  static SessionType fromString(String value) {
    return SessionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SessionType.individual,
    );
  }
}

/// Represents the status of a session note
enum NoteStatus {
  draft('draft'),
  finalized('finalized');

  const NoteStatus(this.value);
  final String value;

  static NoteStatus fromString(String value) {
    return NoteStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => NoteStatus.draft,
    );
  }
}

/// Domain entity representing a session note
class SessionNote {
  final String id;
  final String userProfileId;
  final String patientId;
  final DateTime sessionDate;
  final TimeOfDay sessionStartTime;
  final int sessionDurationMinutes;
  final SessionType sessionType;
  final String content;
  final NoteStatus status;
  final DateTime? finalizedAt;
  final String? unlockReason;
  final DateTime? unlockedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  const SessionNote({
    required this.id,
    required this.userProfileId,
    required this.patientId,
    required this.sessionDate,
    required this.sessionStartTime,
    required this.sessionDurationMinutes,
    required this.sessionType,
    required this.content,
    required this.status,
    this.finalizedAt,
    this.unlockReason,
    this.unlockedAt,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });

  /// Returns true if the note is in draft status
  bool get isDraft => status == NoteStatus.draft;

  /// Returns true if the note is finalized
  bool get isFinalized => status == NoteStatus.finalized;

  /// Returns true if the note has been unlocked after being finalized
  bool get wasUnlocked => unlockReason != null;

  /// Returns true if the note can be edited (draft or unlocked)
  bool get isEditable => isDraft || wasUnlocked;

  /// Creates a copy of this SessionNote with the given fields replaced with new values
  SessionNote copyWith({
    String? id,
    String? userProfileId,
    String? patientId,
    DateTime? sessionDate,
    TimeOfDay? sessionStartTime,
    int? sessionDurationMinutes,
    SessionType? sessionType,
    String? content,
    NoteStatus? status,
    DateTime? finalizedAt,
    String? unlockReason,
    DateTime? unlockedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
  }) {
    return SessionNote(
      id: id ?? this.id,
      userProfileId: userProfileId ?? this.userProfileId,
      patientId: patientId ?? this.patientId,
      sessionDate: sessionDate ?? this.sessionDate,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionDurationMinutes: sessionDurationMinutes ?? this.sessionDurationMinutes,
      sessionType: sessionType ?? this.sessionType,
      content: content ?? this.content,
      status: status ?? this.status,
      finalizedAt: finalizedAt ?? this.finalizedAt,
      unlockReason: unlockReason ?? this.unlockReason,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}
