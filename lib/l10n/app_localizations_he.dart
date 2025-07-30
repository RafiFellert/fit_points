// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'אפליקציית כושר';

  @override
  String get welcomeMessage => 'ברוכים הבאים לאפליקציית הכושר!';

  @override
  String get enterDailyGoal => 'הכנס את היעד היומי';

  @override
  String get enterGoal => 'הכנס יעד (לדוגמא: 100)';

  @override
  String get cancel => 'ביטול';

  @override
  String get save => 'שמירה';

  @override
  String get updateGoal => 'עדכן יעד יומי';

  @override
  String dailyTotal(Object total) {
    return 'סך נקודות ספורט יומיות: $total';
  }

  @override
  String remainingToGoal(Object remaining) {
    return 'נותרו $remaining נקודות ספורט להשלמת היעד היומי';
  }

  @override
  String goalReached(Object goal) {
    return '🎉הגעת ליעד היומי של $goal נקודות ספורט!';
  }

  @override
  String get pushups => 'שכיבות סמיכה';

  @override
  String get pullups => 'עליות מתח';

  @override
  String get squats => 'סקוואטים';

  @override
  String get plank => 'פלאנק (90 שניות)';

  @override
  String get awesomeFitnessApp => 'אפליקציית מעקב הכושר המהממת';

  @override
  String get settings => 'הגדרות';
}
