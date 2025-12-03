import 'package:flutter/material.dart';
import 'pizza.dart';
import '../httphelper.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Pizza pizza;
  final bool isNew;
  const PizzaDetailScreen({
    super.key,
    required this.pizza,
    required this.isNew,
  });

  @override
  State<PizzaDetailScreen> createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  final TextEditingController txtCategory = TextEditingController();
  final TextEditingController txtId = TextEditingController();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtPrice = TextEditingController();
  final TextEditingController txtImageUrl = TextEditingController();

  @override
  void initState() {
    if (!widget.isNew) {
      txtId.text = widget.pizza.id.toString();
      txtName.text = widget.pizza.pizzaName;
      txtDescription.text = widget.pizza.description;
      txtPrice.text = widget.pizza.price.toString();
      txtImageUrl.text = widget.pizza.imageUrl;
    }
    super.initState();
  }

  String operationResult = '';
  @override
  void dispose() {
    txtId.dispose();
    txtName.dispose();
    txtDescription.dispose();
    txtPrice.dispose();
    txtImageUrl.dispose();
    txtCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isNew ? "Add Pizza" : "Edit Pizza")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: txtId,
                decoration: const InputDecoration(labelText: "ID"),
              ),
              TextField(
                controller: txtName,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: txtDescription,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: txtPrice,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: txtImageUrl,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              TextField(
                controller: txtCategory,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: savePizza,
                child: Text(widget.isNew ? "POST Pizza" : "PUT Update"),
              ),

              const SizedBox(height: 20),

              Text(
                operationResult,
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future postPizza() async {
    HttpHelper helper = HttpHelper();

    Pizza pizza = Pizza(
      id: int.tryParse(txtId.text) ?? 0,
      pizzaName: txtName.text,
      description: txtDescription.text,
      imageUrl: txtImageUrl.text,
      price: double.tryParse(txtPrice.text) ?? 0.0,
      category: txtCategory.text,
    );

    String result = await helper.postPizza(pizza);

    setState(() {
      operationResult = result;
    });
  }

  Future savePizza() async {
    HttpHelper helper = HttpHelper();

    Pizza pizza = Pizza(
      id: int.tryParse(txtId.text) ?? 0,
      pizzaName: txtName.text,
      description: txtDescription.text,
      imageUrl: txtImageUrl.text,
      price: double.tryParse(txtPrice.text) ?? 0.0,
      category: txtCategory.text,
    );

    final result = await (widget.isNew
        ? helper.postPizza(pizza)
        : helper.putPizza(pizza));

    setState(() {
      operationResult = result;
    });
  }
}
