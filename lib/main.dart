import 'package:cart_test/cart_bloc.dart';
import 'package:cart_test/cart_event.dart';
import 'package:cart_test/cart_screen.dart';
import 'package:cart_test/cart_state.dart';
import 'package:cart_test/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/cart': (context) => const CartScreen(),
          // '/': (context) => const ProductPage(),
        },
        home: const ProductPage(),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final cartItem = state.items.firstWhere(
                      (item) => item.product.id == product.id,
                      orElse: () => CartItem(product: product, count: 0),
                    );
                    return ListTile(
                      title: Text(products[index].name),
                      subtitle: Text('Price: \$${products[index].price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cartItem.count > 0)
                            IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (cartItem.count == 1) {
                                    context.read<CartBloc>().add(RemoveProduct(product.id));
                                  }
                                  context.read<CartBloc>().add(UpdateProductCount(product.id, cartItem.count - 1));
                                }),
                          if (cartItem.count > 0) Text('${cartItem.count}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              context.read<CartBloc>().add(AddProduct(product));
                            },
                          ),
                          if (cartItem.count > 0)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: cartItem.count > 0
                                  ? () {
                                      context.read<CartBloc>().add(RemoveProduct(product.id));
                                    }
                                  : null,
                            ),
                        ],
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
                const Divider(height: 4),
                const CartList(),
                Text('Subtotal: \$${state.subtotal.toStringAsFixed(2)}'),
                Text('Total Discount: -\$${state.totalDiscount.toStringAsFixed(2)}'),
                Text('Total: \$${state.totalAmount.toStringAsFixed(2)}'),
                Text('${convertCartItemsToMap(state.items)}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cart',
              );
            },
          ),
        ],
      ),
    );
  }
}

List<Product> products = [
  Product(id: '1', name: 'Product 1', price: 10.0, modifiers: [
    Modifier(id: '1', name: 'Extra Cheese', price: 2.0),
    Modifier(id: '2', name: 'Extra Sauce', price: 1.0),
  ]),
  Product(id: '2', name: 'Product 2', price: 5.0),
  Product(id: '3', name: 'Product 3', price: 15.0),
  Product(id: '4', name: 'Product 4', price: 20.0),
  Product(id: '5', name: 'Product 5', price: 25.0),
];
