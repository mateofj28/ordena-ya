import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/data/repositories/firebase_order_repository.dart';
import 'package:ordena_ya/presentation/pages/HomeScreen.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/providers/OrderSetupProvider.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:provider/provider.dart';

import 'domain/usecases/create_order.dart';

void main() {

  final firestore = FirebaseFirestore.instance;
  final orderRepository = FirebaseOrderRepository(firestore);
  final createOrderUseCase = CreateOrder(orderRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderSetupProvider(createOrderUseCase: createOrderUseCase)),
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



