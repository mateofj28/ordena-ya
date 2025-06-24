import 'package:flutter/material.dart';
import 'package:ordena_ya/core/constants/utils/Functions.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../providers/OrderSetupProvider.dart';
import 'AdjustValue.dart';

class ProductModal extends StatelessWidget {
  final String productImage;
  final String productName;
  final String description;
  final double price;
  final String preparationTime;

  const ProductModal({
    super.key,
    required this.productImage,
    required this.productName,
    required this.description,
    required this.price,
    required this.preparationTime,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    width: 30, // ancho del círculo
                    height: 30, // alto del círculo
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        provider.updateProductCount(1)
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20, // tamaño más pequeño
                      ),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Imagen del producto
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(productImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Descripción
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 20),

              // Precio y tiempo de preparación
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Functions.formatCurrency(price),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.redPrimary,
                      ),
                    ),

                    // Tiempo de preparación
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, color: Colors.black, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          preparationTime,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AdjustValue(
                    label: 'Cantidad:',
                    index: provider.productCount,
                    increase: () => provider.increaseProduct(),
                    decrease: () => provider.decreaseProduct(),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Observaciones:'),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.lightGray,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Agregar observaciones especiales.',
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botones de acción
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  label: 'Añadir al carrito',
                  baseColor: AppColors.redPrimary,
                  textColor: Colors.white,
                  onTap: () {
                    print(provider.productCount);

                    final Map<String, dynamic> product = {
                      "productImage": productImage,
                      "productName": productName,
                      "description": description,
                      "price": price,
                      "preparationTime": preparationTime,
                      "quantity": provider.productCount, // tipo int para represent la cantidad
                    };

                    provider.addProductToCart(product);
                    Navigator.of(context).pop();
                  } ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
