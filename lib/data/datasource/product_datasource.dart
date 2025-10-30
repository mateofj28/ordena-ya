import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/data/model/product_model.dart';
import 'package:ordena_ya/data/model/product_models.dart';
import 'package:ordena_ya/core/token/token_storage.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final TokenStorage tokenStorage;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.tokenStorage,
  });

  @override
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final url = ApiConfig.productsEndpoint;
      
      // Obtener token para autenticación
      final token = await tokenStorage.getToken();
      


      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        
        try {
          final Map<String, dynamic> json = jsonDecode(responseBody);
          
          final productResponse = ProductResponseModel.fromJson(json);
          
          // Convertir ProductDataModel a ProductModel (modelo existente)
          final products = productResponse.products.map((productData) {
            return ProductModel(
              id: productData.id,
              name: productData.name,
              unitPrice: productData.price,
              quantity: 1, // Cantidad por defecto
              description: productData.description,
              imageUrl: productData.imageUrl,
              category: productData.category,
              preparationTime: productData.preparationTime.toString(),
              notes: '', // Notas vacías por defecto
            );
          }).toList();
          return products;
        } catch (parseError) {
          throw Exception('Error parsing products response: $parseError');
        }
      } else {
        
        throw Exception('Failed to fetch products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch products from server: $e');
    }
  }
}
