import 'dart:convert';
import './model/pizza.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  List<Pizza> myPizzas = [];
  String pizzaString = '';
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPizzas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: myPizzas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(myPizzas[index].pizzaName),
                  subtitle: Text(myPizzas[index].description),
                );
              },
            ),
    );
  }

  Future<List<Pizza>> readJsonFile() async {
    String myString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/pizzalist.json');

    var pizzaMapList = json.decode(myString);
    return parsePizzas(pizzaMapList);
  }

  List<Pizza> parsePizzas(List<dynamic> pizzaMapList) {
    List<Pizza> list = [];

    for (var pizza in pizzaMapList) {
      list.add(Pizza.fromJson(pizza));
    }
    return list;
  }
}
