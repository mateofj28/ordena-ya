import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import 'package:ordena_ya/domain/repository/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getAllProducts();
  }
}
