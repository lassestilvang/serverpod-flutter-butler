import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, sir.'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, sir.'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, sir.'**
  String get goodEvening;

  /// No description provided for @addSubtaskTo.
  ///
  /// In en, this message translates to:
  /// **'Add Subtask to \"{parent}\"'**
  String addSubtaskTo(Object parent);

  /// No description provided for @subtaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Subtask Title'**
  String get subtaskTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @addNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addNewTask;

  /// No description provided for @readyToExcel.
  ///
  /// In en, this message translates to:
  /// **'Ready to excel, sir?'**
  String get readyToExcel;

  /// No description provided for @cleanSlate.
  ///
  /// In en, this message translates to:
  /// **'Your slate is clean. Let\'s orchestrate your day.'**
  String get cleanSlate;

  /// No description provided for @butlersCounsel.
  ///
  /// In en, this message translates to:
  /// **'The Butler\'s Counsel'**
  String get butlersCounsel;

  /// No description provided for @defaultTip.
  ///
  /// In en, this message translates to:
  /// **'Consistency is the hallmark of excellence, sir.'**
  String get defaultTip;

  /// No description provided for @primaryObjectives.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY OBJECTIVES'**
  String get primaryObjectives;

  /// No description provided for @addSubtask.
  ///
  /// In en, this message translates to:
  /// **'Add Subtask'**
  String get addSubtask;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @timeboxButler.
  ///
  /// In en, this message translates to:
  /// **'TimeBox Butler'**
  String get timeboxButler;

  /// No description provided for @mainTaskLabel.
  ///
  /// In en, this message translates to:
  /// **'What is your main task?'**
  String get mainTaskLabel;

  /// No description provided for @mainTaskHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Refactor Auth Flow'**
  String get mainTaskHint;

  /// No description provided for @magicBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Magic Breakdown'**
  String get magicBreakdown;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining: {time}'**
  String timeRemaining(Object time);

  /// No description provided for @estimatedPomodoro.
  ///
  /// In en, this message translates to:
  /// **'Estimated 1 Pomodoro'**
  String get estimatedPomodoro;

  /// No description provided for @savePlan.
  ///
  /// In en, this message translates to:
  /// **'Save Plan'**
  String get savePlan;

  /// No description provided for @pomodoroCompleted.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Completed! 🍅'**
  String get pomodoroCompleted;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @enterTaskFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task and generate subtasks first.'**
  String get enterTaskFirst;

  /// No description provided for @planSaved.
  ///
  /// In en, this message translates to:
  /// **'Plan Saved Successfully! 💾'**
  String get planSaved;

  /// No description provided for @errorSavingPlan.
  ///
  /// In en, this message translates to:
  /// **'Error saving plan: {error}'**
  String errorSavingPlan(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
