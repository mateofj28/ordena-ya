import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../core/constants/AppColors.dart';
import '../../core/utils/logger.dart';
import '../providers/order_provider.dart';

import '../widgets/new_order_card.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las órdenes cuando se inicializa la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderSetupProvider>().getAllNewOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderSetupProvider>(
      builder: (context, provider, child) {
        if (provider.status == OrderStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Cargando órdenes...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.status == OrderStatus.error) {
          return Scaffold(
            backgroundColor: AppColors.lightGray,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedAlert02,
                    size: 64,
                    color: AppColors.redPrimary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error al cargar órdenes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage ?? 'Error desconocido',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.getAllNewOrders();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redPrimary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.lightGray,
          body: provider.newOrders.isEmpty
              ? const EmptyOrdersView()
              : RefreshIndicator(
                  onRefresh: () => provider.getAllNewOrders(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con información
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Órdenes Activas',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${provider.newOrders.length} órdenes encontradas',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => provider.getAllNewOrders(),
                                icon: const Icon(Icons.refresh),
                                tooltip: 'Actualizar órdenes',
                              ),
                            ],
                          ),
                        ),
                        
                        // Lista de órdenes
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.newOrders.length,
                            itemBuilder: (context, index) {
                              final order = provider.newOrders[index];
                              Logger.info('Mostrando orden: Mesa ${order.mesa}, Estado: ${order.estadoGeneral}');

                              return NewOrderCard(order: order);
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class EmptyOrdersView extends StatelessWidget {
  const EmptyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderSetupProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          HugeIcons.strokeRoundedShoppingBasketRemove03,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        const Text(
          'No hay órdenes disponibles',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Las órdenes aparecerán aquí cuando estén disponibles en el servidor',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            provider.getAllNewOrders();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Actualizar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
