import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';

import '../../core/constants/AppColors.dart';

class ProductListItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final String estimatedTime;
  final VoidCallback onAdd;

  const ProductListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.estimatedTime,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          /// Parte izquierda: imagen (Expanded para ocupar todo el alto disponible)
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1, // opcional: mantiene proporción cuadrada
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Parte derecha: info y botón
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Functions.formatCurrency(price),
                  style: const TextStyle(fontSize: 14, color: AppColors.redPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      estimatedTime,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    ElevatedButton(
                      onPressed: onAdd,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: AppColors.redPrimary,
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Icon(HugeIcons.strokeRoundedAdd01, size: 25, color: Colors.white,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
