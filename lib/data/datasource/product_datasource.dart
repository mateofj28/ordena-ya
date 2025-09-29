import 'package:ordena_ya/data/model/product_model.dart';
import '../../core/network/api_client.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final jsonList = await apiClient.get('/products/all');
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }
}
