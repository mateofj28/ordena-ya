import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordena_ya/core/config/api_config.dart';
import 'package:ordena_ya/core/utils/logger.dart';
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
      
      Logger.info('Fetching products from: $url');
      Logger.info('Token available: ${token != null ? 'YES' : 'NO'}');
      if (token != null) {
        Logger.info('Token (first 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
      }

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
          Logger.error('Fetch products timeout after 15 seconds');
          throw Exception('Request timeout - Check if server is running and accessible');
        },
      );

      Logger.info('Fetch products response status: ${response.statusCode}');
      Logger.info('Fetch products response body: ${response.body}');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        Logger.info('Raw response body: $responseBody');
        
        try {
          final Map<String, dynamic> json = jsonDecode(responseBody);
          Logger.info('Parsed JSON keys: ${json.keys.toList()}');
          
          final productResponse = ProductResponseModel.fromJson(json);
          
          // Convertir ProductDataModel a ProductModel (modelo existente)
          final products = productResponse.products.map((productData) {
            Logger.info(
              'Processing product: ID=${productData.id}, Name=${productData.name}, Price=${productData.price}',
            );
            Logger.info(
              'Product ID length: ${productData.id.length}, Is valid ObjectId: ${productData.id.length == 24}',
            );
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

          Logger.info('Successfully fetched ${products.length} products');
          return products;
        } catch (parseError) {
          Logger.error('Error parsing response: $parseError');
          Logger.error('Response body was: $responseBody');
          throw Exception('Error parsing products response: $parseError');
        }
      } else {
        Logger.error('Failed to fetch products: ${response.statusCode}');
        Logger.error('Response headers: ${response.headers}');
        Logger.error('Response body: ${response.body}');
        
        // Intentar parsear el error del servidor
        try {
          final errorJson = jsonDecode(response.body);
          Logger.error('Server error details: $errorJson');
        } catch (e) {
          Logger.error('Could not parse error response as JSON');
        }
        
        throw Exception('Failed to fetch products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      Logger.error('Error fetching products: $e');
      
      // Mostrar el error real en lugar de devolver lista vacía
      Logger.error('Failed to fetch products from server. Error: $e');
      throw Exception('Failed to fetch products from server: $e');
      
      // COMENTADO: En caso de error del servidor, devolver lista vacía para no crashear la app
      // Logger.info('Returning empty product list due to server error');
      // return [];
    }
  }
}
