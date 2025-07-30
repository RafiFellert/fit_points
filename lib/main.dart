import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:fit_points/l10n/app_localizations.dart';
import 'package:fit_points/providers/locale_provider.dart';
import 'package:fit_points/pages/settings_page.dart'; // Import the settings page

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return DropdownButton<Locale>(
      value: locale,
      icon: const Icon(Icons.language),
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('he'),
          child: Text('עברית'),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          provider.setLocale(newLocale);
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Fit Points',
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: localeProvider.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Fit Points Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageSwitcher(),
          ),
        ],
      ),
      body: Center(
        child: Text(localizations.welcomeMessage),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int pushups = 0;
  int pullUps = 0;
  int legExercise = 0;
  int plank = 0;
  int dailyGoal = 15;

  Timer? _dateCheckTimer;
  late DateTime _lastCheckedDate;

  @override
  void initState() {
    super.initState();
    _lastCheckedDate = DateTime.now();
    _startDateCheckTimer();
    _loadData();
    _startTimer();
  }

  void _startDateCheckTimer() {
    _dateCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.day != _lastCheckedDate.day ||
          now.month != _lastCheckedDate.month ||
          now.year != _lastCheckedDate.year) {
        setState(() {
          pushups = 0;
          pullUps = 0;
          legExercise = 0;
          plank = 0;
        });
        _lastCheckedDate = now;
      }
    });
  }

  DateTime currentDateTime = DateTime.now();
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      setState(() {
        currentDateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _dateCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pushups = prefs.getInt('pushups') ?? 0;
      pullUps = prefs.getInt('pullUps') ?? 0;
      legExercise = prefs.getInt('legExercise') ?? 0;
      plank = prefs.getInt('plank') ?? 0;
      dailyGoal = prefs.getInt('dailyGoal') ?? 100;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pushups', pushups);
    await prefs.setInt('pullUps', pullUps);
    await prefs.setInt('legExercise', legExercise);
    await prefs.setInt('plank', plank);
    await prefs.setInt('dailyGoal', dailyGoal);
  }

  void _increment(String type) {
    setState(() {
      if (type == 'pushup') pushups++;
      if (type == 'pullUps') pullUps++;
      if (type == 'leg') legExercise++;
      if (type == 'plank') plank += 10;
    });
    _saveData();
  }

  void _decrement(String type) {
    setState(() {
      if (type == 'pushup' && pushups > 0) pushups--;
      if (type == 'pullUps' && pullUps > 0) pullUps--;
      if (type == 'leg' && legExercise > 0) legExercise--;
      if (type == 'plnak' && plank > 0) plank -= 10;
    });
    _saveData();
  }

  void _showGoalDialog() {
    // ignore: unused_local_variable
    final controller = TextEditingController(text: dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.enterDailyGoal),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterGoal),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                final input = int.tryParse(controller.text);
                if (input != null && input > 0) {
                  setState(() {
                    dailyGoal = input;
                  });
                  _saveData();
                }
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }
  // Helper to get localized strings
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  int get total => pushups + pullUps + legExercise + plank;
  int get remaining => (dailyGoal - total).clamp(0, dailyGoal);
  bool get goalReached => total >= dailyGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.awesomeFitnessApp),
        backgroundColor: Colors.deepPurple.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              DateFormat('EEEE, MMM d, yyyy – HH:mm').format(currentDateTime),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildExerciseRow(AppLocalizations.of(context)!.pushups, pushups, "pushup"),
            _buildExerciseRow(AppLocalizations.of(context)!.pullups, pullUps, "pullUps"),
            _buildExerciseRow(AppLocalizations.of(context)!.squats, legExercise, "leg"),
            _buildExerciseRow(AppLocalizations.of(context)!.plank, plank, "plank"),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            ElevatedButton(
              onPressed: _showGoalDialog,
              child: Text(AppLocalizations.of(context)!.updateGoal),
            ),
            Text(
              AppLocalizations.of(context)!.dailyTotal(total),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (!goalReached)
              Text(
                AppLocalizations.of(context)!.remainingToGoal(remaining),
                style: const TextStyle(fontSize: 16),
              ),
            if (goalReached)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  AppLocalizations.of(context)!.goalReached(dailyGoal),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseRow(String label, int count, String type) {
  
  String imagePath = '';
  switch (type) {
    case 'pushup':
      imagePath = 'assets/images/pushups.jpg';
      break;
    case 'pullUps':
      imagePath = 'assets/images/pullups.jpg';
      break;
    case 'leg':
      imagePath = 'assets/images/squats.jpg';
      break;
    case 'plank':
      imagePath = 'assets/images/plank.jpg';
      break;
  }    
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => _decrement(type),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _increment(type),
          ),
          const SizedBox(width: 16),
          Text(
            '$count',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
                  const SizedBox(width: 10),
        if (imagePath.isNotEmpty)
          Image.asset(
            imagePath,
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
