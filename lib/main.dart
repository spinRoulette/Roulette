import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class RouletteHomePage extends StatelessWidget {
  const RouletteHomePage({super.key});

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
                    children: const [
                      _CategoryIcon(icon: Icons.calendar_today, label: 'Dzień'),
                      _CategoryIcon(icon: Icons.restaurant, label: 'Jedzenie'),
                      _CategoryIcon(icon: Icons.sports_esports, label: 'Rozrywka'),
                      _CategoryIcon(icon: Icons.music_note, label: 'Muzyka'),
                      _CategoryIcon(icon: Icons.place, label: 'Podróż'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Pie Chart
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
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
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFF7AD1D6),
                                value: 25,
                                showTitle: false,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF2B4263),
                                value: 25,
                                showTitle: false,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFB6E2D3),
                                value: 25,
                                showTitle: false,
                                radius: 80,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFF7D6B3),
                                value: 25,
                                showTitle: false,
                                radius: 80,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                          onPressed: () {},
                          child: const Text('KRĘĆ'),
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
                          onPressed: () {},
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
  const _CategoryIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
