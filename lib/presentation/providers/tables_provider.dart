import 'package:flutter/material.dart';
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/domain/usecase/get_all_tables.dart';

enum TablesState { initial, loading, success, failure }


class TablesProvider extends ChangeNotifier {
  final GetTablesUseCase getTablesUseCase;
  
  TablesState _state = TablesState.initial;
  TablesState get state => _state;

  List<RestaurantTable> _tables = [];
  List<RestaurantTable> get tables => _tables;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TablesProvider({required this.getTablesUseCase});

  Future<void> getTables() async {
    _state = TablesState.loading;
    notifyListeners();
    final result = await getTablesUseCase.call();

    result.fold(
      (failure) {
        _state = TablesState.failure;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (data) {
        _state = TablesState.success;
        _tables = data;
        notifyListeners();
      },
    );
    
  }

  
}
