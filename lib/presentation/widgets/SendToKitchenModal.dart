import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/AppColors.dart';
import '../providers/order_provider.dart';
import 'CircularCloseButton.dart';

class SendTokitchenModal extends StatelessWidget {
  const SendTokitchenModal({super.key});

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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Enviar a cocina',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    CircularCloseButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.grey, height: 0),

              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¿Confirmas el envío de la orden a la cocina?'),
                  ],
                ),
              ),

              Divider(color: Colors.grey, height: 5),

              TextButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  navigator.pop();

                  // Enviar a cocina (actualizar orden en backend)
                  await provider.sendToKitchen();

                  // Verificar el resultado y mostrar mensaje
                  if (provider.status == OrderStatus.success) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          '¡Comanda enviada a cocina exitosamente!',
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          provider.errorMessage ?? 'Error al enviar la comanda',
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.redPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
