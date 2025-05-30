import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

class _MyHomePageState extends State<MyHomePage> {
  int pushups = 0;
  int pullUps = 0;
  int legExercise = 0;
  int plank = 0;

  int dailyGoal = 15;

 @override
  void initState() {
    super.initState();
    _loadData();
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
      if (type == 'plank') plank+=10;
    });
    _saveData();
  }

  void _decrement(String type) {
    setState(() {
      if (type == 'pushup' && pushups > 0) pushups--;
      if (type == 'pullUps' && pullUps > 0) pullUps--;
      if (type == 'leg' && legExercise > 0) legExercise--;
      if (type == 'plnak' && plank > 0) plank-=10;
    });
    _saveData();
  }

  void _showGoalDialog() {
    final controller = TextEditingController(text: dailyGoal.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("הכנס יעד יומי"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "הכנס יעד (לדוגמא: 100)"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ביטול"),
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
              child: const Text("שמירה"),
            ),
          ],
        );
      },
    );
  }
  int get total => pushups + pullUps + legExercise + plank;
  int get remaining => (dailyGoal - total).clamp(0, dailyGoal);
  bool get goalReached => total >= dailyGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("אפליקציית מעקב הכושר המהממת "),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExerciseRow("שכיבות סמיכה", pushups, "pushup"),
            _buildExerciseRow("עליות מתח", pullUps, "pullUps"),
            _buildExerciseRow("סקוואטים", legExercise, "leg"),
            _buildExerciseRow("פלאנק 90 שניות", plank, "plank"),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            ElevatedButton(
              onPressed: _showGoalDialog,
              child: const Text("עדכן יעד יומי"),
            ),
            Text(
              "$total: סך נקודות ספורט יומיות",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (!goalReached)
              Text(
                "$remaining: מספר נקודות ספורט שנותרו להגעה ליעד היומי",
                style: const TextStyle(fontSize: 16),
              ),
            if (goalReached)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "🎉הגעת ליעד היומי של $dailyGoal נקודות ספורט",
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
        ],
      ),
    );
  }
}
