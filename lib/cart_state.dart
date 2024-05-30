import 'package:cart_test/model.dart';

class CartState {
  final List<CartItem> items;

  CartState({this.items = const []});

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.product.price * item.count);
  }

  double get totalDiscount {
    return items.fold(0.0, (sum, item) => sum + item.product.price * item.count * item.discount);
  }

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}