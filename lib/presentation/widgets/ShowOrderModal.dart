import 'package:flutter/material.dart';
import 'package:ordena_ya/core/utils/functions.dart';
import 'order_card.dart';

class ShowOrderModal extends StatelessWidget {
  final Map order;

  const ShowOrderModal({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),

              Align(
                child: Text(
                  'Comanda Mesa ${order['tableName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 30),

              Text('Fecha: ${order['date']}, ${order['time']}'),
              Text('Personas: ${order['people']}'),
              Text('Productos:'),

              ...List.generate(
                order['items'].length,
                    (index) {
                  final product = order['items'][index] as OrderItemRow;
                  return Text(
                    '${product.label} - ${Functions.formatCurrency(product.value)}',
                  );
                },
              ),

              SizedBox(height: 30),

              Text(
                'Total: ${Functions.formatCurrency(order['total'] ?? 00.0)}',
              ),

              const Divider(color: Colors.grey, thickness: 1, height: 20),

              Align(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
