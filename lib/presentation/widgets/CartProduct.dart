import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:provider/provider.dart';

import '../../core/utils/functions.dart';
import '../../domain/entity/cart_item.dart';
import 'AdjustValue.dart';

class CartProduct extends StatelessWidget {
  final CartItem cartItem;
  final int index;

  const CartProduct({super.key, required this.cartItem, required this.index});

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
                  cartItem.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Text(Functions.formatCurrency(cartItem.price)),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdjustValue(
                label: 'Cantidad:',
                index: cartItem.quantity,
                increase: () => provider.increaseCartItemQuantity(index),
                decrease: () => provider.decreaseCartItemQuantity(index),
                canDecrease: provider.canDecreaseQuantityAt(index),
                canIncrease: cartItem.canIncrease,
              ),
              Text(
                Functions.formatCurrency(cartItem.totalPrice),
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
                    controller: TextEditingController(text: cartItem.message),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Agregar observaciones...',
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: (value) => provider.updateCartItemMessage(index, value),
                  ),
                ),
              ),
              Consumer<OrderSetupProvider>(
                builder: (context, deleteProvider, child) {
                  return IconButton(
                    onPressed: deleteProvider.status == OrderStatus.loading || !deleteProvider.canRemoveProductAt(index)
                        ? null 
                        : () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            
                            // Mostrar mensaje de validación si no se puede eliminar
                            if (!deleteProvider.canRemoveProductAt(index)) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text('No se puede eliminar: existen unidades que ya están siendo preparadas o entregadas'),
                                  backgroundColor: Colors.orange,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }
                            
                            await deleteProvider.removeCartItemAt(index);
                            
                            // Mostrar mensaje si hay error
                            if (deleteProvider.status == OrderStatus.error && 
                                deleteProvider.errorMessage != null) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  content: Text(deleteProvider.errorMessage!),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                    icon: deleteProvider.status == OrderStatus.loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                            ),
                          )
                        : HugeIcon(
                            icon: HugeIcons.strokeRoundedDelete02,
                            color: deleteProvider.canRemoveProductAt(index) ? Colors.redAccent : Colors.grey[400]!,
                          ),
                  );
                },
              ),
            ],
          ),

          // Mostrar estados de las unidades si existen
          if (cartItem.unitStates.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _buildStatusIndicators(cartItem.unitStates),
                  ),
                ),
                SizedBox(width: 8),

              ],
            ),
          ],



          // Mostrar error si existe
          if (provider.status == OrderStatus.error && provider.errorMessage != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedAlert02,
                    size: 16,
                    color: Colors.red[700],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      provider.errorMessage = null;
                    },
                    icon: Icon(
                      HugeIcons.strokeRoundedCancel01,
                      size: 16,
                      color: Colors.red[700],
                    ),
                    constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 10),

        ],
      ),
    );
  }

  List<Widget> _buildStatusIndicators(List<String> states) {
    final stateCount = <String, int>{};

    for (final state in states) {
      stateCount[state] = (stateCount[state] ?? 0) + 1;
    }

    return stateCount.entries.map((entry) {
      final status = entry.key;
      final count = entry.value;
      final displayText = count == 1
          ? '(1) ${_getStatusDisplayText(status)}'
          : '($count) ${_getStatusDisplayTextPlural(status)}';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFFFFD54F);
      case 'cocinando':
      case 'en preparación':
      case 'en_preparacion':
        return const Color(0xFFFFB74D);
      case 'listo_para_entregar':
      case 'listo para entregar':
      case 'listo':
        return const Color(0xFF29B6F6);
      case 'entregado':
        return const Color(0xFF81C784);
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendiente';
      case 'cocinando':
      case 'en preparación':
      case 'en_preparacion':
        return 'Cocinando';
      case 'listo_para_entregar':
      case 'listo para entregar':
      case 'listo':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregado';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }

  String _getStatusDisplayTextPlural(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return 'Pendientes';
      case 'cocinando':
      case 'en preparación':
      case 'en_preparacion':
        return 'Cocinando';
      case 'listo_para_entregar':
      case 'listo para entregar':
      case 'listo':
        return 'Listo para entregar';
      case 'entregado':
        return 'Entregados';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
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
