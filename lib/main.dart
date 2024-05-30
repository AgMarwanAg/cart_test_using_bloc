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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Container(
                      color: item.discount > 0 ? Colors.green.withOpacity(0.1) : Colors.transparent,
                      child: ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('Price: \$${item.product.price} x ${item.count} = \$${item.totalPrice}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.count == 1) {
                                  context.read<CartBloc>().add(RemoveProduct(item.product.id));
                                  return;
                                }
                                context.read<CartBloc>().add(UpdateProductCount(item.product.id, item.count - 1));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartBloc>().add(UpdateProductCount(item.product.id, item.count + 1));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context.read<CartBloc>().add(RemoveProduct(item.product.id));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.discount),
                              onPressed: () {
                                const double discount = 0.2;
                                context.read<CartBloc>().add(ApplyDiscount(item.product.id, discount));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                final String productId = item.product.id;
                                context.read<CartBloc>().add(RemoveDiscount(productId));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
              // // Example: Add a product to the cart
              // final product = Product(id: '1', name: 'Product 1', price: 10.0);
              // context.read<CartBloc>().add(AddProduct(product));
            },
          ),
          // FloatingActionButton(
          //   child: const Icon(Icons.add),
          //   onPressed: () {
          //     // Example: Add a product to the cart
          //     final product = Product(id: '2', name: 'Product 2', price: 5.0);
          //     context.read<CartBloc>().add(AddProduct(product));
          //   },
          // ),
        ],
      ),
    );
  }
}

List<Product> products = [
  Product(id: '1', name: 'Product 1', price: 10.0),
  Product(id: '2', name: 'Product 2', price: 5.0),
  Product(id: '3', name: 'Product 3', price: 15.0),
  Product(id: '4', name: 'Product 4', price: 20.0),
  Product(id: '5', name: 'Product 5', price: 25.0),
];
