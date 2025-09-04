import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ordena_ya/core/constants/AppColors.dart';
import 'package:ordena_ya/core/di/get_it.dart';
import 'package:ordena_ya/domain/usecase/add_item_to_order.dart';
import 'package:ordena_ya/domain/usecase/get_order_id.dart';
import 'package:ordena_ya/domain/usecase/get_orders_today.dart';
import 'package:ordena_ya/domain/usecase/set_order_id.dart';
import 'package:ordena_ya/domain/usecase/update_item_in_order.dart';
import 'package:ordena_ya/presentation/pages/HomeScreen.dart';
import 'package:ordena_ya/presentation/providers/MenuProvider.dart';
import 'package:ordena_ya/presentation/providers/order_provider.dart';
import 'package:ordena_ya/presentation/providers/ToggleButtonProvider.dart';
import 'package:provider/provider.dart';
import 'domain/usecase/create_order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => OrderSetupProvider(
                createOrderUseCase: getIt<CreateOrder>(),
                addItemToOrderUseCase: getIt<AddItemToOrderUseCase>(),
                getOrdersTodayUseCase: getIt<GetOrdersTodayUseCase>(),
                getOrderId: getIt<GetOrderIdUseCase>(),
                setOrderId: getIt<SetOrderIdUseCase>(),
                editItem: getIt<UpdateItemInOrderUseCase>(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => ToggleButtonProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MyApp(),
    ),
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.redPrimary),
        scaffoldBackgroundColor: AppColors.whiteBackground,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      home: HomeScreen(),
    );
  }
}
