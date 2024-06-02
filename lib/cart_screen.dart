import 'package:cart_test/cart_bloc.dart';
import 'package:cart_test/cart_event.dart';
import 'package:cart_test/cart_state.dart';
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
              const CartList(),
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

class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final item = state.items[index];
            return Container(
              color: item.discount > 0 ? Colors.green.withOpacity(0.1) : Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
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
                    onTap: item.product.modifiers.isEmpty
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  children: item.product.modifiers.map((modifier) {
                                    return ListTile(
                                      title: Text(modifier.name),
                                      subtitle: Text('Price: \$${modifier.price}'),
                                      trailing: IconButton(
                                        icon: Icon(
                                          item.selectedModifiers.contains(modifier) ? Icons.remove : Icons.add,
                                        ),
                                        onPressed: () {
                                          if (item.selectedModifiers.contains(modifier)) {
                                            context.read<CartBloc>().add(RemoveModifier(item.product.id, modifier));
                                          } else {
                                            context.read<CartBloc>().add(AddModifier(item.product.id, modifier));
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          },
                  ),
                  Text(
                    item.displayModifiers,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
