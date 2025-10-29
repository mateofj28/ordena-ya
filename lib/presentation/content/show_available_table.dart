import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/utils/logger.dart';
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/providers/tables_provider.dart';
import 'package:ordena_ya/presentation/widgets/CircularCloseButton.dart';
import 'package:provider/provider.dart';

class ShowAvailableTable extends StatelessWidget {

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

  Widget _buildBody(TablesProvider provider, BuildContext context) {
    switch (provider.state) {
      case TablesState.loading:
        return const Center(child: CircularProgressIndicator());

      case TablesState.success:
        if (provider.tables.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    color: AppColors.textPrimary,
                    size: 64,
                    icon: HugeIcons.strokeRoundedTable,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No hay mesas disponibles",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Las mesas aparecerán aquí cuando estén registradas en el servidor",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<TablesProvider>().getTables();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Recargar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowStatus,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return buildTablesView(context, provider.tables);

      case TablesState.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  color: AppColors.redTotal,
                  size: 64,
                  icon: HugeIcons.strokeRoundedRssError,
                ),
                const SizedBox(height: 16),
                Text(
                  "Error al cargar mesas",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? "Error desconocido",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TablesProvider>().getTables();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reintentar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redTotal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );

      case TablesState.initial:
        // Cargar automáticamente las mesas cuando se abre el diálogo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<TablesProvider>().getTables();
        });
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildTablesView(BuildContext context, List<RestaurantTable> tables) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 IMPORTANTE
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Gestión de Mesas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CircularCloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey, height: 0),

          
          GridView.builder(
            shrinkWrap: true, 
            physics:
                const NeverScrollableScrollPhysics(), 
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
              return GestureDetector(
                onTap: () {
                  Logger.info('Table tapped: ${table.tableNumber} (${table.status})');
                  if (table.status != 'occupied') {
                    Logger.info('Table is available, proceeding with selection');
                    try {
                      // Usar el nuevo método que guarda la información completa
                      context.read<OrderSetupProvider>().setSelectedTable(table);
                      Logger.info('setSelectedTable called successfully');
                      context.read<TablesProvider>().selectTable(table);
                      Logger.info('TablesProvider.selectTable called successfully');
                      Navigator.pop(context);
                      Logger.info('Modal closed successfully');
                    } catch (e) {
                      Logger.error('Error selecting table: $e');
                    }
                  } else {
                    Logger.info('Table is occupied, cannot select');
                  }
                },
                child: Container(
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  const ShowAvailableTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TablesProvider>();
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: _buildBody(provider, context),
      ),
    );
  }
}
