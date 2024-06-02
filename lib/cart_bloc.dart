import 'package:cart_test/cart_event.dart';
import 'package:cart_test/cart_state.dart';
import 'package:cart_test/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<UpdateProductCount>(_onUpdateProductCount);
    on<ApplyDiscount>(_onApplyDiscount);
    on<RemoveDiscount>(_onRemoveDiscount);
    on<AddModifier>(_onAddModifier);
    on<RemoveModifier>(_onRemoveModifier);
  }

  void _onAddProduct(AddProduct event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.product.id);

    if (index >= 0) {
      updatedItems[index].count += 1;
    } else {
      updatedItems.add(CartItem(product: event.product));
    }

    emit(CartState(items: updatedItems));
  }

  void _onRemoveProduct(RemoveProduct event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(CartState(items: updatedItems));
  }

  void _onUpdateProductCount(UpdateProductCount event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0 && event.count > 0) {
      updatedItems[index].count = event.count;
    }

    emit(CartState(items: updatedItems));
  }

  void _onApplyDiscount(ApplyDiscount event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0 && event.discount >= 0 && event.discount <= 1) {
      updatedItems[index].discount = event.discount;
    }

    emit(CartState(items: updatedItems));
  }

  void _onRemoveDiscount(RemoveDiscount event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      updatedItems[index].discount = 0.0;
    }

    emit(CartState(items: updatedItems));
  }

    void _onAddModifier(AddModifier event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      final modifiers = List<Modifier>.from(updatedItems[index].selectedModifiers)..add(event.modifier);
      updatedItems[index] = updatedItems[index].copyWith(selectedModifiers: modifiers);
    }

    emit(CartState(items: updatedItems));
  }

  void _onRemoveModifier(RemoveModifier event, Emitter<CartState> emit) {
    List<CartItem> updatedItems = List.from(state.items);
    int index = updatedItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      updatedItems[index].selectedModifiers.removeWhere((modifier) => modifier.id == event.modifier.id);
    }

    emit(CartState(items: updatedItems));
  }
}
