class Product {
  final int id;
  final String name;
  final String slack;
   double salePrice;
  final double originalPrice;
  final String imagePath;
  final bool isVariant;
  final bool isStockable;
  final bool isLowStock;
  final bool isOutOfStock;
  final double? tax;
  final List<Discount> discounts;
  final double discount;
  String? selectedDiscount;
  // final List<ProductModifier> selectedModifiers;
  final String note;
  // final OtherTaxesAndFee? otherTaxesAndFee;

  Product({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.slack,
    required this.discounts,
    this.discount = 0.0,
    this.originalPrice = 0.0,
    this.imagePath = '',
    this.isVariant = false,
    this.isStockable = true,
    this.isLowStock = false,
    this.isOutOfStock = false,
    this.tax,
    this.note = '',
   
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': salePrice,
      };
}

class CartItem {
  final Product product;
  int count;
  double discount;

  CartItem({required this.product, this.count = 1, this.discount = 0.0});

  // double get totalPrice => (product.salePrice * count) * (1 - discount);
  double get totalPrice => (product.salePrice * count)  -(count* discount);

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'count': count,
        'discount': discount,
      };
}

List<Map<String, dynamic>> convertCartItemsToMap(List<CartItem> cartItems) {
  return cartItems.map((cartItem) {
    return {'id': cartItem.product.id, 'name': cartItem.product.name, 'amount': cartItem.totalPrice, 'count': cartItem.count};
  }).toList();
}
class Discount  {
    final String name;
   final String typeText;
  final double value;

  const Discount({
      required this.name,
     required this.typeText,
    required this.value,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
         name: json['name'],
         typeText: json['type_text'],
        value: json['value'].toDouble(),
      );
  static List<Discount> fromList(List<dynamic> list) {
    return list.map((item) => Discount.fromJson(item)).toList();
  }

  
}