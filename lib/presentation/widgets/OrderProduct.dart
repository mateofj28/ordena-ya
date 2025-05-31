import 'package:flutter/material.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:provider/provider.dart';

class OrderProduct extends StatelessWidget {
  final dynamic product;
  final int index;
  const OrderProduct({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<OrderSetupProvider>(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        product['name'],
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Precio unitario: \$${product['price']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => cart.increaseProductQuantity(product),
                ),
                Text(
                  '${product['quantity']}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => cart.decreaseProductQuantity(product),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${product['total']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => cart.removeProductFromCart(index),
          ),
        ],
      ),
    );
  }
}
