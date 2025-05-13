import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// Dodaj klasę ThemeProvider
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  static const String _themeKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeMode.toString());
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
    return MaterialApp(
      title: 'Roulette',
      theme: ThemeData(
        brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
              primary: Colors.teal,
              secondary: Colors.tealAccent,
              surface: Colors.white,
              background: Colors.grey[50]!,
              onSurface: Colors.black87,
              onBackground: Colors.black87,
            ),
        useMaterial3: true,
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: const BorderSide(color: Colors.black12, width: 1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black87),
              titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black87,
              size: 32,
            ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
              primary: Colors.teal,
              secondary: Colors.tealAccent,
              surface: const Color(0xFF151C25),
              background: const Color(0xFF0B111A),
              onSurface: Colors.white,
              onBackground: Colors.white,
            ),
        useMaterial3: true,
            cardTheme: CardTheme(
              color: const Color(0xFF151C25),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF151C25),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 32,
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    if (_usernameController.text == 'admin' && _passwordController.text == '1234') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RouletteHomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Nieprawidłowa nazwa użytkownika lub hasło';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: isDark ? null : Border.all(color: Colors.black12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: colorScheme.onSurface,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                ],
              ),
              Text(
                'Logowanie',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Nazwa użytkownika',
                  hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Hasło',
                  hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.2)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: isDark ? Colors.transparent : Colors.black12,
                      width: 1,
                    ),
                  ),
                ),
                onPressed: _login,
                child: const Text('Zaloguj się'),
              ),
            ],
          ),
        ),
      ),
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

  // Dodana baza wyzwań
  final Map<String, List<String>> wyzwania = {
    'Dzień': [
      'Wstań godzinę wcześniej niż zwykle.',
      'Przejdź dziś minimum 10 000 kroków.',
      'Zrezygnuj na jeden dzień z telefonu po godzinie 20:00.',
      'Zrób coś dobrego dla nieznajomej osoby.',
      'Przeznacz 30 minut na porządki w dowolnym miejscu w domu.',
      'Spędź 10 minut medytując lub wykonując ćwiczenia oddechowe.',
      'Zrób listę swoich 5 największych celów na ten rok.',
      'Znajdź 10 minut na czytanie książki lub artykułów.',
      'Przypomnij sobie 3 rzeczy, za które jesteś wdzięczny/a.',
      'Zrób przerwę na 10 minut w pracy i wyjdź na świeże powietrze.',
      'Zaplanuj swój tydzień, zapisując kluczowe zadania.',
      'Zrób coś, co sprawia Ci radość, ale zazwyczaj odkładasz na później.',
      'Napisz listę rzeczy, które chcesz osiągnąć w ciągu najbliższego miesiąca.',
      'Odetnij się na 30 minut od technologii (bez telefonu, komputera).',
      'Spędź 15 minut na porozmawianiu z kimś, kogo długo nie widziałeś/aś.',
    ],
    'Jedzenie': [
      'Ugotuj coś nowego z przepisu z internetu.',
      'Zrób cały dzień bez słodyczy.',
      'Zjedz dziś 5 porcji warzyw.',
      'Przygotuj zdrowe śniadanie z owsianką lub smoothie.',
      'Zrób domową pizzę od podstaw.',
      'Przygotuj sałatkę z 5 różnych składników.',
      'Zjedz dzisiaj pełnowartościowy posiłek na każdą z trzech głównych pór dnia.',
      'Wprowadź do diety owoc, którego jeszcze nie jadłeś/aś.',
      'Odwiedź lokalny targ i kup świeże produkty sezonowe.',
      'Zjedz bez pośpiechu, koncentrując się na smaku jedzenia.',
      'Zrób zdrowy deser bez cukru (np. jogurt z owocami).',
      'Spróbuj gotować w kuchni z innej części świata (np. kuchnia japońska).',
      'Przygotuj szybkie danie w mniej niż 30 minut.',
      'Zrób dzień bez mięsa i spróbuj dań roślinnych.',
      'Zjedz każdy posiłek powoli, starając się docenić smaki i tekstury.',
    ],
    'Rozrywka': [
      'Zagraj w grę planszową lub karcianą.',
      'Obejrzyj film z listy klasyków, których jeszcze nie widziałeś/aś.',
      'Spędź godzinę grając w swoją ulubioną grę — bez poczucia winy.',
      'Znajdź nową grę mobilną i przetestuj ją przez 15 minut.',
      'Przejrzyj stare zdjęcia lub filmy i powspominaj dobre chwile.',
      'Zorganizuj wieczór filmowy z przyjaciółmi lub rodziną.',
      'Spróbuj swoich sił w grze, którą zawsze chciałeś/aś wypróbować.',
      'Stwórz listę ulubionych filmów i obejrzyj jeden z nich.',
      'Odwiedź lokalne muzeum lub galerię sztuki.',
      'Zorganizuj maraton swojej ulubionej serii filmowej.',
      'Przeczytaj książkę, która została Ci polecona przez znajomych.',
      'Poświęć godzinę na naukę nowej gry online lub planszowej.',
      'Zrób sobie przerwę i spędź czas na rozwiązywaniu łamigłówek lub krzyżówek.',
      'Przypomnij sobie swoje ulubione gry z dzieciństwa i zagraj w nie ponownie.',
      'Zorganizuj spontaniczny wieczór karaoke.',
    ],
    'Muzyka': [
      'Posłuchaj przez 30 minut muzyki z innego gatunku niż zwykle.',
      'Stwórz nową playlistę na konkretny nastrój (np. relaks, motywacja).',
      'Naucz się słów jednej nowej piosenki i zaśpiewaj ją.',
      'Odsłuchaj cały album wybranego artysty bez przerzucania utworów.',
      'Znajdź nowego artystę na Spotify/YouTube i posłuchaj 3 jego utworów.',
      'Posłuchaj muzyki z lat 80-90 i przypomnij sobie stare hity.',
      'Zorganizuj wieczór muzyczny z przyjaciółmi, wymieniając się ulubionymi utworami.',
      'Zrób playlistę na długi spacer lub bieganie.',
      'Spędź godzinę grając na instrumencie, nawet jeśli dopiero zaczynasz.',
      'Posłuchaj muzyki instrumentalnej, idealnej do koncentracji.',
      'Odsłuchaj płytę, której nigdy wcześniej nie doceniłeś/aś.',
      'Zrób research na temat swojego ulubionego gatunku muzycznego.',
      'Zaśpiewaj karaoke do ulubionej piosenki.',
      'Odsłuchaj koncert na żywo swojego ulubionego artysty online.',
      'Spędź 30 minut na poznawaniu historii muzyki z danego okresu lub gatunku.',
    ],
    'Podróż': [
      'Wybierz się dziś na spacer po nieznanej okolicy w Twoim mieście.',
      'Zaplanuj weekendową wycieczkę (nawet jeśli tylko na mapie).',
      'Przejdź się trasą, którą jeszcze nigdy nie chodziłeś/aś.',
      'Odwiedź lokalne miejsce, którego wcześniej nie znałeś/aś.',
      'Zrób zdjęcie jak z wakacji — nawet jeśli jesteś niedaleko domu.',
      'Odwiedź park lub ogród botaniczny w Twoim mieście.',
      'Zorganizuj jednodniową wycieczkę do pobliskiej miejscowości.',
      'Zaplanuj podróż do miejsca, które zawsze chciałeś/aś odwiedzić.',
      'Przejdź się do miejsca, gdzie nigdy wcześniej nie byłeś/aś.',
      'Zrób zdjęcia najpiękniejszych miejsc w swojej okolicy.',
      'Przypomnij sobie swoje najpiękniejsze wakacje i zaplanuj przyszłą podróż.',
      'Wybierz się na rowerową wycieczkę do najbliższego parku.',
      'Spędź dzień w innym mieście i spróbuj odkryć jego uroki.',
      'Odwiedź miejsce związane z historią Twojego regionu.',
      'Zrób spontaniczną wycieczkę na łono natury, np. do lasu.',
    ],
  };

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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChallengeScreen(
          category: categories[catIndex],
          challenges: wyzwania[categories[catIndex]] ?? [],
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
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 330,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: colorScheme.background,
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
                          color: colorScheme.onBackground,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              themeProvider.themeMode == ThemeMode.dark
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: colorScheme.onBackground,
                            ),
                            onPressed: () => themeProvider.toggleTheme(),
                      ),
                      CircleAvatar(
                            backgroundColor: colorScheme.surface,
                        radius: 22,
                            child: Icon(Icons.person, color: colorScheme.onSurface, size: 26),
                          ),
                        ],
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
                        colorScheme: colorScheme,
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
                            color: colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: isDark ? null : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                // Zwiększony odstęp i pole na wynik
                SizedBox(height: 16),
                if (!isSpinning && spinningResult != null)
                  Text(
                    'Wylosowano: ${categories[selectedCategory]}',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  const SizedBox(height: 24),
                SizedBox(height: 8),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? colorScheme.surface : Colors.white,
                            foregroundColor: isDark ? Colors.white : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                              side: BorderSide(
                                color: isDark ? Colors.transparent : Colors.black26,
                                width: 1,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            elevation: isDark ? 0 : 2,
                          ),
                          onPressed: _spinRoulette,
                          child: isSpinning
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.teal,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text('KRĘĆ'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: 240,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? colorScheme.surface : Colors.white,
                            foregroundColor: isDark ? Colors.white : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                              side: BorderSide(
                                color: isDark ? Colors.transparent : Colors.black26,
                                width: 1,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                            elevation: isDark ? 0 : 2,
                          ),
                          onPressed: _showAddActivityDialog,
                          child: const Text('DODAJ AKTYWNOŚĆ'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
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
  final ColorScheme colorScheme;

  const _CategoryIcon({
    required this.icon,
    required this.label,
    required this.colorScheme,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final iconColor = isDark
        ? Colors.white.withOpacity(highlighted ? 1 : 0.7)
        : Colors.black.withOpacity(highlighted ? 1 : 0.8);
    final textColor = isDark
        ? Colors.white.withOpacity(highlighted ? 1 : 0.7)
        : Colors.black.withOpacity(highlighted ? 1 : 0.8);

    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: iconColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontWeight: highlighted ? FontWeight.bold : FontWeight.w500,
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? const Color(0xFF2196F3) : Colors.blue[100];
    final textColor = Colors.white;
    final cardColor = isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.9);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Make My Day',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: textColor),
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
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: textColor.withOpacity(0.5)),
              ),
              child: Text(
                drawnChallenge ?? 'Naciśnij przycisk, aby wylosować wyzwanie',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
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
