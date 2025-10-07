class Product {
  final String id;
  final String name;
  final String description;
  final String preparationTime;
  final double unitPrice;
  final String imageUrl;
  final int quantity;
  final String category;
  final String notes;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.preparationTime,
    required this.unitPrice,
    required this.imageUrl,
    required this.quantity,
    required this.category,
    required this.notes
  });

  Product copyWith({
    String? id,
    String? name,
     String? description,
     double? unitPrice,
     String? imageUrl,
     String? preparationTime,
    int? quantity,
    String? category,
    String? notes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      preparationTime: preparationTime ?? this.preparationTime,    
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      notes: notes ?? this.notes
    );
  }
}
