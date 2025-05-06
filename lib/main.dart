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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0B111A) : Colors.white;
    final cardColor = isDark ? const Color(0xFF151C25) : const Color(0xFFF5F5F5);
    final textColor = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    child: Icon(Icons.person, color: iconColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _CategoryIcon(icon: Icons.calendar_today, label: 'Dzień'),
                  _CategoryIcon(icon: Icons.restaurant, label: 'Jedzenie'),
                  _CategoryIcon(icon: Icons.sports_esports, label: 'Rozrywka'),
                  _CategoryIcon(icon: Icons.music_note, label: 'Muzyka'),
                  _CategoryIcon(icon: Icons.place, label: 'Podróż'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Pie Chart
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: const Color(0xFF7AD1D6),
                      value: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      color: const Color(0xFF2B4263),
                      value: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      color: const Color(0xFFB6E2D3),
                      value: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      color: const Color(0xFFF7D6B3),
                      value: 25,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? cardColor : Colors.black,
                        foregroundColor: isDark ? Colors.white : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                      child: const Text('KRĘĆ'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? cardColor : const Color(0xFFF5F5F5),
                        foregroundColor: isDark ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {},
                      child: const Text('DODAJ AKTYWNOŚĆ'),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom bar
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, size: 32, color: isDark ? Colors.white : Colors.black87),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
