import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ordena_ya/core/utils/Functions.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/presentation/providers/user_provider.dart';
import 'package:ordena_ya/presentation/widgets/CustomButton.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../providers/order_provider.dart';
import 'AdjustValue.dart';
import 'CircularCloseButton.dart';

class ProductModal extends StatefulWidget {
  final Product product;

  const ProductModal({super.key, required this.product});

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  final TextEditingController _observationsController = TextEditingController();

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);
    final clientProvider = Provider.of<UserProvider>(context);
    final clientId = clientProvider.currentClient?.id;

    final String base64Part = widget.product.imageUrl.split(",")[1];
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
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  CircularCloseButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      provider.productCount = 1;
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Imagen del producto
              SizedBox(
                height: 200,
                width: double.infinity,
                child: SvgPicture.string(
                  utf8.decode(base64Decode(base64Part)),
                  width: 150,
                  height: 150,
                ),
              ),

              const SizedBox(height: 10),

              // Descripción
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.product.description,
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
                      Functions.formatCurrency(widget.product.unitPrice),
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
                          widget.product.preparationTime,
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
                          controller: _observationsController,
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
                    final updatedProduct = widget.product.copyWith(
                      quantity: provider.productCount,
                      notes: _observationsController.text,
                    );

                    if (clientId != null && clientId.isNotEmpty) {
                      provider.clientId = clientId;
                    }                  
                    provider.productCount = 1;
                    provider.addProductToCart(updatedProduct);
                    provider.goToPage(1);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
