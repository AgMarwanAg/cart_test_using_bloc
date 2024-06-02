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
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
        ),
        body: SingleChildScrollView(
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
                    subtitle: Text('Price: \$${products[index].salePrice}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (cartItem.count > 0)
                          IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (cartItem.count == 1) {
                                  context.read<CartBloc>().add(RemoveProduct(product.slack));
                                }
                                context.read<CartBloc>().add(UpdateProductCount(product.slack, cartItem.count - 1));
                              }),
                        if (cartItem.count > 0) Text('${cartItem.count}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            context.read<CartBloc>().add(AddProduct(product));
                          },
                        ),
                      ],
                    ),
                  );
                },
                itemCount: products.length,
              ),
              const Divider(height: 4),
              const CartWidget(),
              Text('Subtotal: \$${state.subtotal.toStringAsFixed(2)}'),
              Text('Total Discount: -\$${state.totalDiscount.toStringAsFixed(2)}'),
              Text('Total: \$${state.totalAmount.toStringAsFixed(2)}'),
              Text('${convertCartItemsToMap(state.items)}'),
            ],
          ),
        ),
        floatingActionButton: Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/cart',
                );
              },
            ),
            Visibility(
              visible: state.items.isNotEmpty,
              child: PositionedDirectional(
                top: -5,
                start: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    state.items.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class CartWidget extends StatelessWidget {
  const CartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartBloc>().state;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return Container(
          color: item.discount > 0 ? Colors.green.withOpacity(0.1) : Colors.transparent,
          child: ListTile(
            title: Text(item.product.name),
            subtitle: Text('Price: \$${item.product.salePrice} x ${item.count} = \$${item.totalPrice}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (item.count == 1) {
                      context.read<CartBloc>().add(RemoveProduct(item.product.slack));
                      return;
                    }
                    context.read<CartBloc>().add(UpdateProductCount(item.product.slack, item.count - 1));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.read<CartBloc>().add(UpdateProductCount(item.product.slack, item.count + 1));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<CartBloc>().add(RemoveProduct(item.product.slack));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.discount),
                  onPressed: () {
                    double discount = calculateDiscount(item.product.salePrice, item.product.discounts.first);
                    // // double discount = calculateDiscount(item.product.salePrice, item.product.discounts.first);
                    context.read<CartBloc>().add(ApplyDiscount(item.product.slack, discount));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    final String productId = item.product.slack;
                    context.read<CartBloc>().add(RemoveDiscount(productId));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Product> products = [
  Product(id: 1, name: 'Product 1', salePrice: 10.0, slack: 's1', discounts: [const Discount(name: 'd1', typeText: '%', value: 10)]),
  Product(id: 2, name: 'Product 2', salePrice: 5.0, slack: 's2', discounts: [const Discount(name: 'd1', typeText: '%', value: 5)]),
  Product(id: 3, name: 'Product 3', salePrice: 15.0, slack: 's3', discounts: [const Discount(name: 'd1', typeText: '%', value: 20)]),
  Product(id: 4, name: 'Product 4', salePrice: 20.0, slack: 's4', discounts: [const Discount(name: 'd1', typeText: ' ', value: 8)]),
  Product(id: 5, name: 'Product 5', salePrice: 25.0, slack: 's5', discounts: [const Discount(name: 'd1', typeText: '%', value: 50)]),
];

double calculateDiscount(double price, Discount? discount) {
  if (discount != null) {
    if (discount.typeText.contains('%')) {
      double discountValue = price * (discount.value / 100);
      return discountValue;
    } else {
      return discount.value;
    }
  } else {
    return 0.0;
  }
}
