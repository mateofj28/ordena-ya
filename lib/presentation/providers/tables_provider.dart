import 'package:flutter/material.dart';
import 'package:ordena_ya/domain/usecase/get_all_tables.dart';


class TablesProvider extends ChangeNotifier {
  final GetTablesUseCase getTablesUseCase;
  


  TablesProvider({required this.getTablesUseCase});

  Future<void> getTables() async {
    
  }

  
}
