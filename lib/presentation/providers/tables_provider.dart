import 'package:flutter/material.dart';
import 'package:ordena_ya/data/model/select_table_model.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/domain/entity/restaurant_table.dart';
import 'package:ordena_ya/domain/usecase/get_all_products.dart';
import 'package:ordena_ya/domain/usecase/get_all_tables.dart';
import 'package:ordena_ya/domain/usecase/select_table.dart';

enum TablesState { initial, loading, success, failure }

class TablesProvider extends ChangeNotifier {
  final GetTablesUseCase getTablesUseCase;
  final SelectTableUseCase selectTableUseCase;
  final GetAllProductsUseCase getAllProductsUseCase; 

  TablesState _state = TablesState.initial;
  TablesState _selectTableState = TablesState.initial;
  TablesState _getProductState = TablesState.initial;

  TablesState get state => _state;
  TablesState get selectTableState => _selectTableState;
  TablesState get getProductState => _getProductState;

  RestaurantTable? _table;
  List<RestaurantTable> _tables = [];
  List<Product> _products = [];

  List<RestaurantTable> get tables => _tables;
  RestaurantTable? get table => _table;
  List<Product> get products => _products;

  String? _errorMessage;
  String? _tableSelectionError;
  String? _getProductsError;

  String? get errorMessage => _errorMessage;
  String? get tableSelectionError => _tableSelectionError;
  String? get getProductsError => _getProductsError;

  TablesProvider({
    required this.getTablesUseCase,
    required this.selectTableUseCase,
    required this.getAllProductsUseCase
  }){
    getProducts();
  }

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

  Future<void> getProducts() async {
    _getProductState = TablesState.loading;
    notifyListeners();
    final result = await getAllProductsUseCase.call();

    result.fold(
      (failure) {
        _getProductState = TablesState.failure;
        _getProductsError = failure.message;
        notifyListeners();
      },
      (data) {
        _getProductState = TablesState.success;
        _products = data;
        notifyListeners();
      },
    );
  }

  Future<void> selectTable(RestaurantTable newTable) async {
    /*_selectTableState = TablesState.loading;
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
    );*/

    _table = newTable;
    notifyListeners();
  }
}
