import 'package:cart_test/model.dart';

abstract class CartEvent {}

class AddProduct extends CartEvent {
  final Product product;

  AddProduct(this.product);
}

class RemoveProduct extends CartEvent {
  final String productId;

  RemoveProduct(this.productId);
}

class UpdateProductCount extends CartEvent {
  final String productId;
  final int count;

  UpdateProductCount(this.productId, this.count);
}

class ApplyDiscount extends CartEvent {
  final String productId;
  final double discount;

  ApplyDiscount(this.productId, this.discount);
}
class RemoveDiscount extends CartEvent {
  final String productId;

  RemoveDiscount(this.productId);
}