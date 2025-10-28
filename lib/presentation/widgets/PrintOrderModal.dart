import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'package:ordena_ya/presentation/widgets/custom_button.dart';
import 'package:ordena_ya/presentation/widgets/LabelValueRow.dart';
import 'order_card.dart';
import 'TicketDivider.dart';

class PrintOrderModal extends StatelessWidget {
  final Map order;

  const PrintOrderModal({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(height: 10),

              Text(
                'MOBILSOFT SAS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                'Calle 109 #18b-51',
              ),

              Text(
                'Bogotá D.C., Colombia',
              ),

              Text(
                'Tel: +57 321 456 7890 / Email:',
              ),

              Text(
                'info@mobilsoft.com',
              ),

              TicketDivider(),
              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMANDA #0',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Fecha: ${order['date']}',
                    ),
                    Text(
                      'Hora: ${order['time']}',
                    ),
                    Text(
                      'Mesa: ${order['tableName']}',
                    ),
                    Text(
                      'Personas: ${order['people']}',
                    ),
                  ],
                ),
              ),

              TicketDivider(),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cant',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Descripción',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Precio',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              ...List.generate(order['items'].length, (index) {
                final product = order['items'][index] as OrderItemRow;
                return Text(
                  '${product.label} - ${Functions.formatCurrency(product.value)}',
                );
              }),

              SizedBox(height: 10),
              TicketDivider(),

              LabelValueRow(label: 'TOTAL', labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), value: Functions.formatCurrency(order['total'])),

              SizedBox(height: 10),
              Text(
                'Gracias por su preferencia!',
              ),
              Text(
                '27/08/2023, 12:45 a. m.',
              ),

              SizedBox(height: 20),

              CustomButton(
                label: 'Imprimir',
                baseColor: Colors.green,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pop()
              )
            ],
          ),
        ),
      ),
    );
  }
}
