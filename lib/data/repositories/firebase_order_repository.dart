// data/repositories/firebase_order_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../model/order_model.dart';

class FirebaseOrderRepository implements ClientRepository {
  final FirebaseFirestore firestore;

  FirebaseOrderRepository(this.firestore);

  @override
  Future<void> createOrder(Order order) async {
    final model = OrderModel.fromEntity(order);
    await firestore.collection('orders').add(model.toJson());
  }

  @override
  Future<List<Order>> getAllOrders() async {
    final querySnapshot =
        await firestore
            .collection('orders')
            .orderBy(
              'orderDate',
              descending: true,
            ) // 👈 orden por fecha, de más reciente a más antigua
            .get();
    return querySnapshot.docs
        .map((doc) => OrderModel.fromJson(doc.data()).toEntity())
        .toList();
  }
}
