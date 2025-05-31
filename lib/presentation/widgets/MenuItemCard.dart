import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:provider/provider.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final int price;
  final String description;
  final Widget? image;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image ?? const Icon(Icons.fastfood),
          ),
          const SizedBox(width: 12),

          // Contenido
          Expanded(
            child: Stack(
              children: [
                // Información principal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre y precio
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            price.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Descripción
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: AppColors.text),
                    ),
                    const SizedBox(height: 30), // espacio para botón
                  ],
                ),

                // Botón en la esquina inferior derecha
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: (){

                      var product = {
                        "name": name,
                        "price": price,
                        "quantity": 1,
                        "total": price,
                      };
                      
                      provider.addProductToCart(product);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Center(
                        child: Icon(Icons.add)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
