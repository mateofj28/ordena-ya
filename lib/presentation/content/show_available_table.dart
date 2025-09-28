import 'package:flutter/material.dart';
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/presentation/widgets/CircularCloseButton.dart';

class ShowAvailableTable extends StatelessWidget {
  final List<RestaurantTable> tables = [
    RestaurantTable(
      id: 1,
      tenantId: 10,
      tableNumber: "Mesa 1",
      capacity: 4,
      status: "available",
      location: "Terraza",
    ),
    RestaurantTable(
      id: 2,
      tenantId: 10,
      tableNumber: "Mesa 2",
      capacity: 2,
      status: "occupied",
      location: "Interior",
    ),
    RestaurantTable(
      id: 3,
      tenantId: 10,
      tableNumber: "Mesa 3",
      capacity: 6,
      status: "occupied",
      location: "Terraza",
    ),
    RestaurantTable(
      id: 4,
      tenantId: 10,
      tableNumber: "Mesa 4",
      capacity: 4,
      status: "available",
      location: "Salón Principal",
    ),
    RestaurantTable(
      id: 5,
      tenantId: 10,
      tableNumber: "Mesa 5",
      capacity: 8,
      status: "occupied",
      location: "VIP",
    ),
  ];

  Color _getColor(String status) {
    switch (status) {
      case "occupied":
        return Colors.redAccent;
      case "available":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'occupied':
        return 'Ocupada';
      case 'available':
        return 'Disponible';
      default:
        return status; // Si viene algo inesperado lo mostramos tal cual
    }
  }

  ShowAvailableTable({super.key});

  @override
  Widget build(BuildContext context) {
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
            mainAxisSize: MainAxisSize.min, // 👈 IMPORTANTE
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Gestion de Mesas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircularCloseButton(
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.grey, height: 0),

              // 👇 Eliminamos Expanded y ajustamos GridView
              GridView.builder(
                shrinkWrap: true, // 👈 permite que se ajuste al contenido
                physics:
                    const NeverScrollableScrollPhysics(), // 👈 evita scroll interno
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: _getColor(table.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.tableNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${table.capacity} personas",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _translateStatus(table.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
