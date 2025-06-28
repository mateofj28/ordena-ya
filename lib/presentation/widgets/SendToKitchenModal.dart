import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/OrderSubmittedModal.dart';
import 'package:provider/provider.dart';
import '../../core/constants/AppColors.dart';
import '../providers/OrderSetupProvider.dart';
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  provider.advanceOrderedProductsStates();
                  provider.enableSendToKitchen = false;
                  provider.enableCloseBill = true;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return OrderSubmittedModal(
                        icon: HugeIcons.strokeRoundedCheckmarkBadge03,
                        iconColor: Colors.green,
                        title: '¡Comanda enviada!',
                        message: 'La comanda ha sido enviada a la cocina correctamente.',
                        buttonLabel: 'Aceptar',
                        onConfirm: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                child: Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.redPrimary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
