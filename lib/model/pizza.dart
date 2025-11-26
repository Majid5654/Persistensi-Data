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
      // Step 3: Handle String-to-int + null
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      // Step 5 & 6: Ensure safe string for String fields
      pizzaName: json['pizzaName']?.toString() == 'null'
          ? 'No name'
          : (json['pizzaName']?.toString() ?? 'No Name'),

      description: json['description']?.toString() == 'null'
          ? ''
          : (json['description']?.toString() ?? ''),

      imageUrl: json['imageUrl']?.toString() ?? '',

      // Step 7–8: Handle String-to-Double error
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    );
  }

  // For JSON encoding (Step 9)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pizzaName": pizzaName,
      "description": description,
      "imageUrl": imageUrl,
      "price": price,
    };
  }

  @override
  String toString() {
    return 'Pizza(id: $id, name: $pizzaName, price: $price)';
  }
  
}
