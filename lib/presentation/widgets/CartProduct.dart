import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/utils/Functions.dart';
import 'AdjustValue.dart';

class CartProduct extends StatelessWidget {
  final dynamic product;
  final int index;

  const CartProduct({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product['productName'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Text(Functions.formatCurrency(product['price'])),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdjustValue(
                label: 'Cantidad:',
                index: product['quantity'],
                increase: () => provider.increaseProductQuantity(product),
                decrease: () => provider.decreaseProductQuantity(product),
              ),
              Text(
                Functions.formatCurrency(product['price']*product['quantity']),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Agregar observaciones...',
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  provider.removeProductFromCart(product['productName']);
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

        ],
      ),
    );
  }
}

/*ListTile(
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
title: Text(
product['name'],
style: const TextStyle(fontWeight: FontWeight.w600),
),
subtitle: Text(
'Precio unitario: ${Functions.formatCurrencyINT(product['unitPrice'])}',
),
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
onPressed: () => cart.decreaseProductQuantity(product),
),
Text(
'${product['quantity']}',
style: const TextStyle(fontSize: 16),
),
IconButton(
icon: const Icon(Icons.add),
onPressed: () => cart.increaseProductQuantity(product),
),
],
),
),
const SizedBox(width: 12),
Text(
Functions.formatCurrencyINT(product['total']),
style: const TextStyle(fontWeight: FontWeight.bold),
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.redAccent),
onPressed: () => cart.removeProductFromCart(index),
),
],
),
);*/
