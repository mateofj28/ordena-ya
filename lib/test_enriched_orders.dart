// Archivo temporal para probar las órdenes enriquecidas
// Este archivo se puede eliminar después de confirmar que todo funciona

import 'package:flutter/material.dart';
import 'package:ordena_ya/data/model/enriched_order_model.dart';
import 'package:ordena_ya/presentation/widgets/enriched_order_card.dart';

class TestEnrichedOrdersScreen extends StatelessWidget {
  const TestEnrichedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear una orden de prueba con la nueva estructura enriquecida
    final testOrder = EnrichedOrderModel(
      id: '6902a1f8c997bee0a5c4ea57',
      orderType: 'table',
      tableId: '69027b8248ad048a952f31cc',
      peopleCount: 2,
      requestedProducts: [
        EnrichedOrderProduct(
          productId: '6901ba37c2539974d6fc90c2',
          productSnapshot: EnrichedProductSnapshot(
            name: 'Agua Mineral',
            price: 2.5,
            category: 'bebidas',
            description: 'Agua mineral natural sin gas, servida fría. Botella de 500ml.',
          ),
          requestedQuantity: 2,
          message: 'Sin hielo',
          statusByQuantity: [
            EnrichedProductStatus(index: 1, status: 'entregado'),
            EnrichedProductStatus(index: 2, status: 'pendiente'),
          ],
        ),
        EnrichedOrderProduct(
          productId: '6901ba37c2539974d6fc90bb',
          productSnapshot: EnrichedProductSnapshot(
            name: 'Pizza Margherita',
            price: 15.99,
            category: 'platos',
            description: 'Pizza clásica italiana con salsa de tomate, mozzarella fresca y albahaca.',
          ),
          requestedQuantity: 1,
          message: 'Masa delgada',
          statusByQuantity: [
            EnrichedProductStatus(index: 1, status: 'en_preparacion'),
          ],
        ),
      ],
      itemCount: 3,
      total: 20.99,
      createdAt: DateTime.now().subtract(Duration(minutes: 15)),
      status: 'received',
      tableInfo: EnrichedTableInfo(
        number: 5,
        capacity: 8,
        location: 'Salón de eventos',
        status: 'occupied',
      ),
      companyInfo: EnrichedCompanyInfo(
        name: 'Smart-Fit Restaurant',
        businessName: 'Smart-Fit Restaurant SAS',
        address: 'Calle 123 #45-67',
      ),
      createdByInfo: EnrichedCreatorInfo(
        name: 'Juan Pérez',
        email: 'juan@restaurant.com',
        role: 'mesero',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Órdenes Enriquecidas'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Orden de Prueba con Información Enriquecida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            EnrichedOrderCard(order: testOrder),
            SizedBox(height: 16),
            Text(
              'Esta orden muestra:\n'
              '• Información de mesa enriquecida (número, ubicación, capacidad)\n'
              '• Productos con snapshot histórico\n'
              '• Estados por unidad con colores\n'
              '• Información del creador\n'
              '• Botones Ver, Imprimir y Editar',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// Para probar, puedes agregar esta ruta temporalmente en main.dart:
// '/test-enriched': (context) => TestEnrichedOrdersScreen(),