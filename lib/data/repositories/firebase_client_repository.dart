// data/repositories/firebase_order_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordena_ya/data/model/client_model.dart';
import 'package:ordena_ya/domain/entities/client.dart';
import 'package:ordena_ya/domain/repositories/client_repository.dart';



class FirebaseClientRepository implements ClientRepository {
  final FirebaseFirestore firestore;

  FirebaseClientRepository(this.firestore);

  @override
  Future<void> createClient(Client client) async {
    final model = ClientModel.fromEntity(client);
    await firestore.collection('client').add(model.toJson());
  }

  @override
  Future<List<Client>> getAllClients() async {
    final querySnapshot = await firestore.collection('client').get();
    return querySnapshot.docs
        .map((doc) => ClientModel.fromJson(doc.data()).toEntity())
        .toList();
  }
}
