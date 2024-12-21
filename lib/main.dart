import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(const JokesApp());
}

class JokesApp extends StatelessWidget {
  const JokesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Laughs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
      home: const JokesScreen(),
    );
  }
}

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> with SingleTickerProviderStateMixin {
  String? currentJoke;
  List<String> cachedJokes = [];
  bool isLoading = false;
  bool isOffline = false;
  bool isLiked = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    checkConnectivity();
    loadCachedJokes();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOffline = result == ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  Future<void> fetchJokes() async {
    await checkConnectivity();
    if (isOffline) {
      if (cachedJokes.isNotEmpty) {
        _showNewJoke(cachedJokes[Random().nextInt(cachedJokes.length)]);
      } else {
        _showSnackBar("You're offline and no cached jokes are available");
      }
      return;
    }

    setState(() {
      isLoading = true;
      isLiked = false;
    });

    try {
      final response = await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Any?amount=5'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> newJokes = (data['jokes'] as List)
            .map((joke) => joke['joke'] ?? "${joke['setup']} ${joke['delivery']}")
            .cast<String>()
            .toList();

        final prefs = await SharedPreferences.getInstance();
        cachedJokes.addAll(newJokes);
        await prefs.setString('cachedJokes', jsonEncode(cachedJokes));

        _showNewJoke(newJokes[0]);
      } else {
        throw Exception('Failed to fetch jokes');
      }
    } catch (e) {
      _showSnackBar('Failed to fetch jokes. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showNewJoke(String joke) {
    _animationController.reset();
    setState(() {
      currentJoke = joke;
    });
    _animationController.forward();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> loadCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cachedJokes');
    if (cachedData != null) {
      setState(() {
        cachedJokes = List<String>.from(jsonDecode(cachedData));
        currentJoke = cachedJokes.isNotEmpty
            ? cachedJokes[Random().nextInt(cachedJokes.length)]
            : "Welcome to Daily Laughs! Tap below to get started.";
      });
      _animationController.forward();
    } else {
      setState(() {
        currentJoke = "Welcome to Daily Laughs! Tap below to get started.";
      });
      _animationController.forward();
    }
  }

  void _shareJoke() {
    _showSnackBar('Joke copied to clipboard!');
    // Implement actual sharing functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Daily Laughs',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isOffline ? Icons.wifi_off : Icons.wifi,
              color: isOffline ? Colors.red : Colors.green,
            ),
            tooltip: isOffline ? 'Offline Mode' : 'Online',
            onPressed: checkConnectivity,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  Expanded(
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentJoke ?? "No joke available",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isLiked ? Icons.favorite : Icons.favorite_border,
                                        color: isLiked ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () => setState(() => isLiked = !isLiked),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(Icons.share, color: Colors.grey),
                                      onPressed: _shareJoke,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : fetchJokes,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    isOffline ? 'Show Offline Joke' : 'Get New Joke',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}