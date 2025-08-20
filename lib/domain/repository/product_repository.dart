// domain/repositories/product_repository.dart
import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import '../entity/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, List<Product>>> getAllProducts();
}
