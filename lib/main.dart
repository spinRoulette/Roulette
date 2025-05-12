import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roulette',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const RouletteHomePage(),
    );
  }
}

class RouletteHomePage extends StatefulWidget {
  const RouletteHomePage({super.key});

  @override
  State<RouletteHomePage> createState() => _RouletteHomePageState();
}

class _RouletteHomePageState extends State<RouletteHomePage> with SingleTickerProviderStateMixin {
  final List<String> categories = ['Dzień', 'Jedzenie', 'Rozrywka', 'Muzyka', 'Podróż'];
  final List<IconData> icons = [
    Icons.calendar_today,
    Icons.restaurant,
    Icons.sports_esports,
    Icons.music_note,
    Icons.place,
  ];
  final List<Color> pieColors = [
    Color(0xFF7AD1D6),
    Color(0xFF2B4263),
    Color(0xFFB6E2D3),
    Color(0xFFF7D6B3),
    Color(0xFF7AD1D6),
  ];
  Map<String, List<String>> activities = {};
  int selectedCategory = 0;
  int? spinningResult;
  double angle = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isSpinning = false;
            selectedCategory = spinningResult!;
          });
        }
      });
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var cat in categories) {
        activities[cat] = prefs.getStringList('activities_$cat') ?? [];
      }
    });
  }

  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    for (var cat in categories) {
      await prefs.setStringList('activities_$cat', activities[cat] ?? []);
    }
  }

  void _spinRoulette() {
    if (isSpinning) return;
    isSpinning = true;
    spinningResult = Random().nextInt(categories.length);
    double spins = 4 + spinningResult! / categories.length;
    angle = spins * 2 * pi;
    _controller.reset();
    _controller.forward();
  }

  void _showAddActivityDialog() async {
    String? newActivity;
    int catIndex = selectedCategory;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151C25),
          title: const Text('Dodaj aktywność', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: catIndex,
                dropdownColor: const Color(0xFF151C25),
                style: const TextStyle(color: Colors.white),
                items: List.generate(categories.length, (i) => DropdownMenuItem(
                  value: i,
                  child: Text(categories[i], style: const TextStyle(color: Colors.white)),
                )),
                onChanged: (v) {
                  setState(() { catIndex = v!; });
                  Navigator.of(context).pop();
                  _showAddActivityDialog();
                },
              ),
              TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: 'Aktywność', hintStyle: TextStyle(color: Colors.white54)),
                onChanged: (v) => newActivity = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                if (newActivity != null && newActivity!.trim().isNotEmpty) {
                  setState(() {
                    activities[categories[catIndex]]!.add(newActivity!.trim());
                  });
                  _saveActivities();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Dodaj', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showActivitiesDialog(int catIndex) {
    showDialog(
      context: context,
      builder: (context) {
        final acts = activities[categories[catIndex]] ?? [];
        return AlertDialog(
          backgroundColor: const Color(0xFF151C25),
          title: Text(categories[catIndex], style: const TextStyle(color: Colors.white)),
          content: acts.isEmpty
              ? const Text('Brak aktywności', style: TextStyle(color: Colors.white70))
              : SizedBox(
                  width: 250,
                  child: ListView(
                    shrinkWrap: true,
                    children: acts.map((a) => ListTile(
                      title: Text(a, style: const TextStyle(color: Colors.white)),
                    )).toList(),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openChallengeScreen(int catIndex) {
    // Przykładowa baza wyzwań dla każdej kategorii
    final Map<String, List<String>> challengeBase = {
      'Dzień': [
        'Zrób 10 przysiadów!',
        'Wyjdź na 5-minutowy spacer.',
        'Napisz komuś miłą wiadomość.',
      ],
      'Jedzenie': [
        'Spróbuj nowego przepisu.',
        'Zjedz owoc, którego dawno nie jadłeś.',
        'Przygotuj zdrową przekąskę.',
      ],
      'Rozrywka': [
        'Zagraj w ulubioną grę przez 10 minut.',
        'Obejrzyj zabawny filmik.',
        'Narysuj coś śmiesznego.',
      ],
      'Muzyka': [
        'Posłuchaj nowej piosenki.',
        'Zaśpiewaj swoją ulubioną piosenkę.',
        'Stwórz krótką playlistę.',
      ],
      'Podróż': [
        'Zaplanuj wycieczkę na weekend.',
        'Otwórz mapę i wybierz losowe miejsce do odwiedzenia.',
        'Zrób zdjęcie ciekawego miejsca w okolicy.',
      ],
    };
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChallengeScreen(
          category: categories[catIndex],
          challenges: challengeBase[categories[catIndex]] ?? [],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = true; // Wymuszamy ciemny motyw jak na zdjęciu
    final bgColor = const Color(0xFF0B111A);
    final cardColor = const Color(0xFF151C25);
    final textColor = Colors.white;
    final iconColor = Colors.white;
    final borderColor = const Color(0xFF232A34);
    final buttonBg = cardColor;
    final buttonText = Colors.white;
    final button2Bg = cardColor;
    final button2Text = Colors.white.withOpacity(0.85);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 330,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      Text(
                        'Roulette',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: cardColor,
                        radius: 22,
                        child: Icon(Icons.person, color: iconColor, size: 26),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(categories.length, (i) => GestureDetector(
                      onTap: () => _openChallengeScreen(i),
                      child: _CategoryIcon(
                        icon: icons[i],
                        label: categories[i],
                        highlighted: selectedCategory == i,
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 8),
                // Pie Chart z animacją
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animation.value * angle,
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 180,
                              width: 180,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 38,
                                  borderData: FlBorderData(show: false),
                                  sections: List.generate(categories.length, (i) => PieChartSectionData(
                                    color: pieColors[i],
                                    value: 25,
                                    showTitle: false,
                                    radius: 80,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!isSpinning && spinningResult != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Wylosowano: ${categories[selectedCategory]}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonBg,
                            foregroundColor: buttonText,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            elevation: 0,
                          ),
                          onPressed: _spinRoulette,
                          child: isSpinning ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('KRĘĆ'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: button2Bg,
                            foregroundColor: button2Text,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.1),
                            elevation: 0,
                          ),
                          onPressed: _showAddActivityDialog,
                          child: const Text('DODAJ AKTYWNOŚĆ'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0, top: 8),
                  child: Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  const _CategoryIcon({required this.icon, required this.label, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.white.withOpacity(highlighted ? 1 : 0.7)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(highlighted ? 1 : 0.7),
            fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _RouletteWheelPainter extends CustomPainter {
  final int segments;
  final double angle;
  final List<Color> colors;
  _RouletteWheelPainter({required this.segments, required this.angle, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final borderPaint = Paint()
      ..color = const Color(0xFF23232E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final segmentAngle = 2 * pi / segments;
    // Draw segments
    for (int i = 0; i < segments; i++) {
      fillPaint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.92),
        i * segmentAngle,
        segmentAngle,
        true,
        fillPaint,
      );
    }
    // Draw border
    canvas.drawCircle(center, radius * 0.92, borderPaint);
    // Draw inner circle
    final innerPaint = Paint()
      ..color = const Color(0xFF23232E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.38, innerPaint);
    // Draw center yellow
    final centerPaint = Paint()
      ..color = const Color(0xFFF5C94A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.28, centerPaint);
    // Draw pointer
    final pointerPaint = Paint()
      ..color = const Color(0xFFF5C94A)
      ..style = PaintingStyle.fill;
    final pointerLength = radius * 0.92 - radius * 0.28;
    final pointerWidth = radius * 0.13;
    final pointerAngle = -pi / 2 + angle; // always up
    final pointerPath = Path();
    pointerPath.moveTo(center.dx, center.dy);
    pointerPath.lineTo(
      center.dx + cos(pointerAngle) * (radius * 0.28),
      center.dy + sin(pointerAngle) * (radius * 0.28),
    );
    pointerPath.lineTo(
      center.dx + cos(pointerAngle) * (radius * 0.28 + pointerLength),
      center.dy + sin(pointerAngle) * (radius * 0.28 + pointerLength),
    );
    pointerPath.arcTo(
      Rect.fromCircle(
        center: Offset(
          center.dx + cos(pointerAngle) * (radius * 0.28 + pointerLength),
          center.dy + sin(pointerAngle) * (radius * 0.28 + pointerLength),
        ),
        radius: pointerWidth,
      ),
      pointerAngle - pi / 2,
      pi,
      false,
    );
    pointerPath.close();
    canvas.drawPath(pointerPath, pointerPaint);
    // Draw segment lines
    final linePaint = Paint()
      ..color = const Color(0xFF23232E)
      ..strokeWidth = size.width * 0.045;
    for (int i = 0; i < segments; i++) {
      final angle = i * segmentAngle;
      final p1 = Offset(
        center.dx + cos(angle) * (radius * 0.92),
        center.dy + sin(angle) * (radius * 0.92),
      );
      final p2 = Offset(
        center.dx + cos(angle) * (radius * 0.38),
        center.dy + sin(angle) * (radius * 0.38),
      );
      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChallengeScreen extends StatefulWidget {
  final String category;
  final List<String> challenges;
  const ChallengeScreen({super.key, required this.category, required this.challenges});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> with TickerProviderStateMixin {
  String? drawnChallenge;
  bool spinning = false;
  late final AnimationController _spinController;
  late final Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _spinAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(parent: _spinController, curve: Curves.easeOut));
    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          spinning = false;
          drawnChallenge = (widget.challenges.toList()..shuffle()).first;
        });
      }
    });
  }

  void drawChallenge() {
    if (widget.challenges.isEmpty || spinning) return;
    setState(() {
      spinning = true;
      drawnChallenge = null;
    });
    _spinController.reset();
    _spinController.forward();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Make My Day', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _spinController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 32),
                child: CustomPaint(
                  painter: _RouletteWheelPainter(
                    segments: 6,
                    angle: 0,
                    colors: [
                      const Color(0xFFF5C94A), // żółty
                      const Color(0xFF4AC9A7), // zielony
                      const Color(0xFFE94B4B), // czerwony
                      const Color(0xFF4AC9A7),
                      const Color(0xFFE94B4B),
                      const Color(0xFF4AC9A7),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Text(
                drawnChallenge ?? 'Naciśnij przycisk, aby wylosować wyzwanie',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2196F3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                elevation: 2,
              ),
              onPressed: drawChallenge,
              child: spinning
                  ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Color(0xFF2196F3), strokeWidth: 3))
                  : const Text('Losuj wyzwanie'),
            ),
          ],
        ),
      ),
    );
  }
}
