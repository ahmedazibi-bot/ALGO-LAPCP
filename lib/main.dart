import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/roadmap_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlgoLapcpApp());
}

class AlgoLapcpApp extends StatelessWidget {
  const AlgoLapcpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALGO/LAPCP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const RoadmapScreen(),
    );
  }
}

class AppState extends ChangeNotifier {
  int _currentDay = 1;
  int _weeklyMinutes = 0;
  final int _weeklyTarget = 120;
  List<Module> _modules = [];
  SharedPreferences? _prefs;

  int get currentDay => _currentDay;
  int get weeklyMinutes => _weeklyMinutes;
  int get weeklyTarget => _weeklyTarget;
  List<Module> get modules => _modules;

  AppState() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _prefs = await SharedPreferences.getInstance();
    _loadModules();
    _currentDay = _prefs?.getInt('currentDay') ?? 1;
    _weeklyMinutes = _prefs?.getInt('weeklyMinutes') ?? 0;
    notifyListeners();
  }

  void _loadModules() {
    _modules = _generateDefaultModules();
    _applySavedProgress();
  }

  List<Module> _generateDefaultModules() {
    return [
      Module(
        title: 'Statistic 1',
        chapters: [
          Chapter(id: 's1_1', title: '1. Generalites et notion de base', isUnlocked: true),
          Chapter(id: 's1_2', title: '2. Representation des donnees', isUnlocked: false),
          Chapter(id: 's1_3', title: '3. Parametres de position', isUnlocked: false),
          Chapter(id: 's1_4', title: '4. Parametres de dispersion', isUnlocked: false),
          Chapter(id: 's1_5', title: '5. Statistique descriptive bivariee', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Statistic 2 & Probabilites',
        chapters: [
          Chapter(id: 's2_1', title: '1. Analyse combinatoire', isUnlocked: false),
          Chapter(id: 's2_2', title: '2. Variables aleatoires', isUnlocked: false),
          Chapter(id: 's2_3', title: '3. Echantillonnage', isUnlocked: false),
          Chapter(id: 's2_4', title: '4. Estimation statistique', isUnlocked: false),
          Chapter(id: 's2_5', title: '5. Tests d\'hypotheses', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Logical Thinking',
        chapters: [
          Chapter(id: 'lt_1', title: '1. Meaning of Algorithm', isUnlocked: false),
          Chapter(id: 'lt_2', title: '2. Variables and data types', isUnlocked: false),
          Chapter(id: 'lt_3', title: '3. User interaction', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Conditions',
        chapters: [
          Chapter(id: 'cond_1', title: '1. Series structure', isUnlocked: false),
          Chapter(id: 'cond_2', title: '2. If / Else conditions', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Loops',
        chapters: [
          Chapter(id: 'loop_1', title: '1. For loop', isUnlocked: false),
          Chapter(id: 'loop_2', title: '2. While loop', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Arrays',
        chapters: [
          Chapter(id: 'arr_1', title: '1. 1D and 2D arrays', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Functions',
        chapters: [
          Chapter(id: 'func_1', title: '1. Functions and procedures', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Languages',
        chapters: [
          Chapter(id: 'lang_1', title: '1. C language', isUnlocked: false),
          Chapter(id: 'lang_2', title: '2. C++ language', isUnlocked: false),
          Chapter(id: 'lang_3', title: '3. Python', isUnlocked: false),
        ],
      ),
      Module(
        title: 'Final Tests',
        chapters: [
          Chapter(id: 'final_1', title: '1. Python Institute PCAD', isUnlocked: false),
          Chapter(id: 'final_2', title: '2. IBM Data Science Certificate', isUnlocked: false),
        ],
      ),
    ];
  }

  void _applySavedProgress() {
    for (var module in _modules) {
      for (var chapter in module.chapters) {
        chapter.isCompleted = _prefs?.getBool('completed_${chapter.id}') ?? false;
      }
    }
    _updateUnlockStates();
  }

  void _updateUnlockStates() {
    bool previousCompleted = true;
    for (var module in _modules) {
      for (var chapter in module.chapters) {
        if (chapter.id == 's1_1') {
          chapter.isUnlocked = true;
          previousCompleted = chapter.isCompleted;
        } else {
          chapter.isUnlocked = previousCompleted;
          previousCompleted = chapter.isCompleted;
        }
      }
    }
    notifyListeners();
  }

  Future<void> markChapterComplete(String chapterId) async {
    for (var module in _modules) {
      for (var chapter in module.chapters) {
        if (chapter.id == chapterId) {
          chapter.isCompleted = true;
          await _prefs?.setBool('completed_$chapterId', true);
          break;
        }
      }
    }
    _updateUnlockStates();
    notifyListeners();
  }

  double getWeeklyProgress() {
    return (_weeklyMinutes / _weeklyTarget).clamp(0.0, 1.0);
  }

  int getCompletedChaptersCount() {
    int count = 0;
    for (var module in _modules) {
      for (var chapter in module.chapters) {
        if (chapter.isCompleted) count++;
      }
    }
    return count;
  }

  int getTotalChaptersCount() {
    int count = 0;
    for (var module in _modules) {
      count += module.chapters.length;
    }
    return count;
  }
}

class Module {
  final String title;
  final List<Chapter> chapters;
  Module({required this.title, required this.chapters});
}

class Chapter {
  final String id;
  final String title;
  bool isUnlocked;
  bool isCompleted;
  Chapter({
    required this.id,
    required this.title,
    this.isUnlocked = false,
    this.isCompleted = false,
  });
}