import 'package:flutter/material.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/domain/usecase/get_all_tables.dart';
import 'package:ordena_ya/domain/usecase/select_table.dart';

enum TablesState { initial, loading, success, failure }

class TablesProvider extends ChangeNotifier {
  final GetTablesUseCase getTablesUseCase;
  final SelectTableUseCase selectTableUseCase;

  TablesState _state = TablesState.initial;
  TablesState _selectTableState = TablesState.initial;

  TablesState get state => _state;
  TablesState get selectTableState => _selectTableState;

  RestaurantTable? _table;
  List<RestaurantTable> _tables = [];
  List<RestaurantTable> get tables => _tables;
  RestaurantTable? get table => _table;

  String? _errorMessage;
  String? _tableSelectionError;

  String? get errorMessage => _errorMessage;
  String? get tableSelectionError => _tableSelectionError;

  TablesProvider({
    required this.getTablesUseCase,
    required this.selectTableUseCase,
  });

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

  Future<void> selectTable(int id, SelectTableModel newTable) async {
    _selectTableState = TablesState.loading;
    notifyListeners();

    final result = await selectTableUseCase.call(id, newTable);

    result.fold(
      (failure) {
        _selectTableState = TablesState.failure;
        _tableSelectionError = failure.message;
        notifyListeners();
      },
      (createdTable) {
        _table = createdTable;
        _selectTableState = TablesState.success;
        notifyListeners();
      },
    );
  }
}
