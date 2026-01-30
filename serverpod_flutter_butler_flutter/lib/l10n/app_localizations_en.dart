// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get goodMorning => 'Good morning, sir.';

  @override
  String get goodAfternoon => 'Good afternoon, sir.';

  @override
  String get goodEvening => 'Good evening, sir.';

  @override
  String addSubtaskTo(Object parent) {
    return 'Add Subtask to \"$parent\"';
  }

  @override
  String get subtaskTitle => 'Subtask Title';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get editTask => 'Edit Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get save => 'Save';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get readyToExcel => 'Ready to excel, sir?';

  @override
  String get cleanSlate => 'Your slate is clean. Let\'s orchestrate your day.';

  @override
  String get butlersCounsel => 'The Butler\'s Counsel';

  @override
  String get defaultTip => 'Consistency is the hallmark of excellence, sir.';

  @override
  String get primaryObjectives => 'PRIMARY OBJECTIVES';

  @override
  String get addSubtask => 'Add Subtask';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get timeboxButler => 'TimeBox Butler';

  @override
  String get mainTaskLabel => 'What is your main task?';

  @override
  String get mainTaskHint => 'e.g., Refactor Auth Flow';

  @override
  String get magicBreakdown => 'Magic Breakdown';

  @override
  String timeRemaining(Object time) {
    return 'Time Remaining: $time';
  }

  @override
  String get estimatedPomodoro => 'Estimated 1 Pomodoro';

  @override
  String get savePlan => 'Save Plan';

  @override
  String get pomodoroCompleted => 'Pomodoro Completed! 🍅';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get enterTaskFirst =>
      'Please enter a task and generate subtasks first.';

  @override
  String get planSaved => 'Plan Saved Successfully! 💾';

  @override
  String errorSavingPlan(Object error) {
    return 'Error saving plan: $error';
  }
}
