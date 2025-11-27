import 'dart:convert';
import './model/pizza.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Demo Majid',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future readAndWritePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appCounter = prefs.getInt('appCounter') ?? 0;
    appCounter++;

    await prefs.setInt('appCounter', appCounter);
    setState(() {
      appCounter = appCounter;
    });
  }

  int appCounter = 0;
  List<Pizza> myPizzas = [];
  String pizzaString = '';

  @override
  void initState() {
    super.initState();
    readAndWritePreference();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readJsonFile().then((value) {
        setState(() {
          myPizzas = value;
          pizzaString = value.toString();
        });
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'You have opened the app $appCounter times.',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                deletePreference();
              },
              child: const Text('Reset counter'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Pizza>> readJsonFile() async {
    String myString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/pizzalist.json');

    var pizzaMapList = json.decode(myString);

    List<Pizza> pizzas = parsePizzas(pizzaMapList);

    String jsonOutput = convertToJSON(pizzas);
    print(jsonOutput);

    return pizzas;
  }

  List<Pizza> parsePizzas(List<dynamic> pizzaMapList) {
    List<Pizza> list = [];

    for (var pizza in pizzaMapList) {
      list.add(Pizza.fromJson(pizza as Map<String, dynamic>));
    }
    return list;
  }

  String convertToJSON(List<Pizza> pizzas) {
    return jsonEncode(pizzas.map((p) => p.toJson()).toList());
  }

  Future resetCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appCounter', 0);

    setState(() {
      appCounter = 0;
    });
  }

  Future deletePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      appCounter = 0;
    });
  }
}
