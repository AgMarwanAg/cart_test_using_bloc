class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

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

  CartItem({required this.product, this.count = 1, this.discount = 0.0});

  double get totalPrice => (product.price * count) * (1 - discount);


  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'count': count,
    'discount': discount,
  };
}  List<Map<String, dynamic>> convertCartItemsToMap(List<CartItem> cartItems) {
  return cartItems.map((cartItem) {
    return {
      'id': cartItem.product.id,
      'name': cartItem.product.name,
      'amount': cartItem.totalPrice,
      'count':cartItem.count
    };
  }).toList();
  }
