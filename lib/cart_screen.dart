import 'package:cart_test/cart_bloc.dart';
import 'package:cart_test/cart_event.dart';
import 'package:cart_test/cart_state.dart';
import 'package:cart_test/main.dart';
import 'package:cart_test/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Column(
            children: [
              const CartWidget(),
              Text('Subtotal: \$${state.subtotal.toStringAsFixed(2)}'),
              Text('Total Discount: -\$${state.totalDiscount.toStringAsFixed(2)}'),
              Text('Total: \$${state.totalAmount.toStringAsFixed(2)}'),
              Text('${convertCartItemsToMap(state.items)}'),
            ],
          );
        },
      ),
    );
  }
}
