import 'dart:convert';
import './model/pizza.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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
  String documentsPath = '';
  String tempPath = '';
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
    getPaths();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Path Provider')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Doc path: $documentsPath'),
          Text('Temp path $tempPath'),
        ],
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

  Future getPaths() async {
    final docDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();

    setState(() {
      documentsPath = docDir.path;
      tempPath = tempDir.path;
    });
  }
}
