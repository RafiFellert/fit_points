// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gym App';

  @override
  String get welcomeMessage => 'Welcome to the Gym App!';

  @override
  String get enterDailyGoal => 'Enter Daily Goal';

  @override
  String get enterGoal => 'Enter Goal (e.g.: 100)';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get updateGoal => 'Update Daily Goal';

  @override
  String dailyTotal(Object total) {
    return 'Total Daily Fitness Points: $total';
  }

  @override
  String remainingToGoal(Object remaining) {
    return 'Remaining to reach your daily goal: $remaining';
  }

  @override
  String goalReached(Object goal) {
    return '🎉 You\'ve reached your daily goal of $goal fitness points!';
  }

  @override
  String get pushups => 'Push-ups';

  @override
  String get pullups => 'Pull-ups';

  @override
  String get squats => 'Squats';

  @override
  String get plank => 'Plank (90 seconds)';

  @override
  String get awesomeFitnessApp => 'Awesome Fitness Tracker App';

  @override
  String get settings => 'Settings';
}
