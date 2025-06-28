import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/presentation/widgets/OrderSubmittedModal.dart';
import 'package:provider/provider.dart';
import '../../core/constants/AppColors.dart';
import '../providers/OrderSetupProvider.dart';


class CloseBillModal extends StatelessWidget {

  const CloseBillModal({super.key});

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
                      '¿Deseas cerrar la cuenta?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    Text('La información se enviará a caja para emitir la factura electrónica.'),
                  ],
                ),
              ),

              Divider(color: Colors.grey, height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.lightGray)),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      provider.clearCart();
                      provider.enableCloseBill = false;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OrderSubmittedModal(
                            icon: HugeIcons.strokeRoundedInvoice03,
                            iconColor: Colors.green,
                            title: '¡Cuenta cerrada!',
                            message: 'La comanda ha sido enviada a caja para generar la factura electrónica DIAN.',
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
              )

            ],
          ),
        ),
      ),
    );
  }
}
