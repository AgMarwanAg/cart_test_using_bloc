class Product {
  final String id;
  final String name;
  final double price;
  final List<Modifier> modifiers;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.modifiers = const [],
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };
}

class CartItem {
  final Product product;
  int count;
  double discount;
  List<Modifier> selectedModifiers;

  CartItem({
    required this.product,
    this.count = 1,
    this.discount = 0.0,
    this.selectedModifiers = const [],
  });

  double get totalModifierPrice {
    return selectedModifiers.fold(0.0, (sum, modifier) => sum + modifier.price);
  }

  // double get totalPrice => (product.price * count) * (1 - discount);
  double get totalPrice {
    final basePrice = product.price * count;
    final discountAmount = basePrice * discount;
    return basePrice - discountAmount + totalModifierPrice;
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'count': count,
        'discount': discount,
      };
  String get displayModifiers {
    final modifiers = selectedModifiers.map((m) => m.name).join(', ');
    // return '${product.name}${modifiers.isNotEmpty ? ' with $modifiers' : ''}';
    return modifiers;
  }

  CartItem copyWith({
    Product? product,
    int? count,
    double? discount,
    List<Modifier>? selectedModifiers,
  }) =>
      CartItem(
        product: product ?? this.product,
        count: count ?? this.count,
        discount: discount ?? this.discount,
        selectedModifiers: selectedModifiers ?? this.selectedModifiers,
      );
}

List<Map<String, dynamic>> convertCartItemsToMap(List<CartItem> cartItems) {
  return cartItems.map((cartItem) {
    return {'id': cartItem.product.id, 'name': cartItem.product.name, 'amount': cartItem.totalPrice, 'count': cartItem.count};
  }).toList();
}

class Modifier {
  final String id;
  final String name;
  final double price;

  Modifier({required this.id, required this.name, required this.price});
}
