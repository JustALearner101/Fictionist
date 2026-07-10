// File: lib/presentation/features/manuscript/provider/session_goals_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the user's daily writing goals and streak.
class SessionGoals {
  /// The user's daily word count goal. 0 means no goal is set.
  final int dailyGoal;

  /// Total words written today (cumulative across sessions).
  final int wordsWrittenToday;

  /// Current consecutive-day streak of writing.
  final int currentStreak;

  /// All-time best streak.
  final int bestStreak;

  /// Timestamp of the most recent write action.
  final DateTime? lastWriteDate;

  const SessionGoals({
    this.dailyGoal = 0,
    this.wordsWrittenToday = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastWriteDate,
  });

  SessionGoals copyWith({
    int? dailyGoal,
    int? wordsWrittenToday,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastWriteDate,
    bool clearLastWriteDate = false,
  }) {
    return SessionGoals(
      dailyGoal: dailyGoal ?? this.dailyGoal,
      wordsWrittenToday: wordsWrittenToday ?? this.wordsWrittenToday,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastWriteDate:
          clearLastWriteDate ? null : lastWriteDate ?? this.lastWriteDate,
    );
  }
}

/// Notifier managing [SessionGoals] and the streak logic.
///
/// ## Streak rules
/// - **Same day** → accumulate `wordsWrittenToday`; streak unchanged.
/// - **Yesterday**  → `wordsWrittenToday` resets to `count`; streak +1.
/// - **Older gap**  → `wordsWrittenToday` resets to `count`; streak resets to 1.
class SessionGoalsNotifier extends StateNotifier<SessionGoals> {
  SessionGoalsNotifier() : super(const SessionGoals());

  /// Set (or change) the daily word goal.
  void setDailyGoal(int goal) {
    state = state.copyWith(dailyGoal: goal);
  }

  /// Record that the user just wrote [count] new words.
  ///
  /// Call this after every meaningful edit / auto‑save pulse.
  void recordWords(int count) {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final lastWrite = state.lastWriteDate;

    if (lastWrite == null) {
      // Very first write
      state = state.copyWith(
        wordsWrittenToday: count,
        currentStreak: 1,
        bestStreak: 1,
        lastWriteDate: now,
      );
      return;
    }

    final lastDate = _dateOnly(lastWrite);
    final gap = today.difference(lastDate).inDays;

    if (gap == 0) {
      // Same calendar day — accumulate
      state = state.copyWith(
        wordsWrittenToday: state.wordsWrittenToday + count,
        lastWriteDate: now,
      );
    } else if (gap == 1) {
      // Consecutive day — streak continues
      final newStreak = state.currentStreak + 1;
      state = state.copyWith(
        wordsWrittenToday: count,
        currentStreak: newStreak,
        bestStreak: newStreak > state.bestStreak ? newStreak : state.bestStreak,
        lastWriteDate: now,
      );
    } else {
      // Gap of 2+ days — streak broken
      state = state.copyWith(
        wordsWrittenToday: count,
        currentStreak: 1,
        lastWriteDate: now,
      );
    }
  }

  /// Reset today's word count (e.g. at midnight).
  void resetDailyCount() {
    state = state.copyWith(wordsWrittenToday: 0);
  }

  /// Strip time component for day-level comparison.
  DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);
}

/// Global provider for session goals / streak state.
final sessionGoalsProvider =
    StateNotifierProvider<SessionGoalsNotifier, SessionGoals>(
  (ref) => SessionGoalsNotifier(),
);
