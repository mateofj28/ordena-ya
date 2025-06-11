import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/data/repositories/firebase_client_repository.dart';
import 'package:ordena_ya/data/repositories/firebase_order_repository.dart';
import 'package:ordena_ya/domain/usecases/create_client.dart';
import 'package:ordena_ya/domain/usecases/get_all_orders.dart';
import 'package:ordena_ya/presentation/pages/HomeScreen.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:provider/provider.dart';

import 'domain/usecases/create_order.dart';

import 'package:firebase_core/firebase_core.dart'; // <-- Esto también falta
// Asegúrate de tener el archivo firebase_options.dart si usas FlutterFire CLI
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final orderRepository = FirebaseOrderRepository(firestore);
  final clientRepository = FirebaseClientRepository(firestore);

  final createOrderUseCase = CreateOrder(orderRepository);
  final createClientUseCase = CreateClient(clientRepository);
  final getAllOrdersUseCase = GetAllOrders(orderRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderSetupProvider(createOrderUseCase: createOrderUseCase, getAllOrdersUseCase: getAllOrdersUseCase, createClientUseCase: createClientUseCase)),
        ChangeNotifierProvider(create: (_) => ToggleButtonProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MyApp()
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrdenaYa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryButton),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomeScreen(),
    );
  }
}



