import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/domain/entity/cart_item.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  final Function(String) onMessageChanged;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onMessageChanged,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late TextEditingController _messageController;
  bool _showMessageField = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.cartItem.message);
    _showMessageField = widget.cartItem.message.isNotEmpty;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre y botón eliminar
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.cartItem.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: const Icon(
                  HugeIcons.strokeRoundedDelete02,
                  color: Colors.red,
                  size: 20,
                ),
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Precio unitario y total
          Row(
            children: [
              Text(
                'Precio unitario: ${Functions.formatCurrencyINT(widget.cartItem.price.toInt())}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                'Total: ${Functions.formatCurrencyINT(widget.cartItem.totalPrice.toInt())}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redPrimary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Controles de cantidad
          Row(
            children: [
              const Text(
                'Cantidad:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: widget.cartItem.quantity > 1
                          ? () => widget.onQuantityChanged(widget.cartItem.quantity - 1)
                          : null,
                      icon: const Icon(HugeIcons.strokeRoundedRemove01),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        widget.cartItem.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.cartItem.quantity < 99
                          ? () => widget.onQuantityChanged(widget.cartItem.quantity + 1)
                          : null,
                      icon: const Icon(HugeIcons.strokeRoundedAdd01),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Botón para agregar/editar mensaje
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showMessageField = !_showMessageField;
                  });
                },
                icon: Icon(
                  _showMessageField 
                      ? HugeIcons.strokeRoundedArrowUp01
                      : HugeIcons.strokeRoundedEdit02,
                  size: 16,
                ),
                label: Text(
                  _showMessageField ? 'Ocultar' : 'Mensaje',
                  style: const TextStyle(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          
          // Campo de mensaje (expandible)
          if (_showMessageField) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _messageController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Agregar observaciones especiales...',
                  hintStyle: TextStyle(fontSize: 14),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: widget.onMessageChanged,
              ),
            ),
          ],
          
          // Mostrar mensaje actual si existe y no está en modo edición
          if (!_showMessageField && widget.cartItem.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedMessage01,
                    size: 16,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.cartItem.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}