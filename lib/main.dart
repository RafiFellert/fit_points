import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int handWeights = 0;
  int legExercise = 0;

  final int dailyGoal = 5;

 @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pushups = prefs.getInt('pushups') ?? 0;
      handWeights = prefs.getInt('handWeights') ?? 0;
      legExercise = prefs.getInt('legExercise') ?? 0;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pushups', pushups);
    await prefs.setInt('handWeights', handWeights);
    await prefs.setInt('legExercise', legExercise);
  }

  void _increment(String type) {
    setState(() {
      if (type == 'pushup') pushups++;
      if (type == 'hand') handWeights++;
      if (type == 'leg') legExercise++;
    });
    _saveData();
  }

  void _decrement(String type) {
    setState(() {
      if (type == 'pushup' && pushups > 0) pushups--;
      if (type == 'hand' && handWeights > 0) handWeights--;
      if (type == 'leg' && legExercise > 0) legExercise--;
    });
    _saveData();
  }

  int get total => pushups + handWeights + legExercise;
  int get remaining => (dailyGoal - total).clamp(0, dailyGoal);
  bool get goalReached => total >= dailyGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Personal Fitness Tracker"),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExerciseRow("Pushups", pushups, "pushup"),
            _buildExerciseRow("Hand Weights", handWeights, "hand"),
            _buildExerciseRow("Leg Exercise", legExercise, "leg"),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            Text(
              "Total Repetitions: $total",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (!goalReached)
              Text(
                "Repetitions left to reach goal: $remaining",
                style: const TextStyle(fontSize: 16),
              ),
            if (goalReached)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "🎉 You reached your $dailyGoal repetitions daily goal!",
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
