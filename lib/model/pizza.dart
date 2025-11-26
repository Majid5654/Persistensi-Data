const keyId = 'id';
const keyName = 'pizzaName';
const keyDescription = 'description';
const keyPrice = 'price';
const keyImage = 'imageUrl';

class Pizza {
  int id;
  String pizzaName;
  String description;
  String imageUrl;
  double price;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  // --- Practical 2 Improvements ---
  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: int.tryParse(json[keyId]?.toString() ?? '') ?? 0,
      pizzaName: json[keyName]?.toString() == 'null'
          ? 'No name'
          : (json[keyName]?.toString() ?? 'No Name'),
      description: json[keyDescription]?.toString() == 'null'
          ? ''
          : (json[keyDescription]?.toString() ?? ''),
      imageUrl: json[keyImage]?.toString() ?? '',
      price: double.tryParse(json[keyPrice]?.toString() ?? '') ?? 0.0,
    );
  }

  // For JSON encoding (Step 9)
  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyName: pizzaName,
      keyDescription: description,
      keyImage: imageUrl,
      keyPrice: price,
    };
  }

  @override
  String toString() {
    return 'Pizza(id: $id, name: $pizzaName, price: $price)';
  }
}
