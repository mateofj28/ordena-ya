import 'package:ordena_ya/core/model/either.dart';
import 'package:ordena_ya/core/model/failure.dart';
import 'package:ordena_ya/data/datasource/product_datasource.dart';
import 'package:ordena_ya/domain/entity/product.dart';
import '../../domain/repository/product_repository.dart';


class ProductRepositoryImpl implements ProductRepository {

  final ProductRemoteDataSource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, Product>> createProduct(Product product) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final products = await datasource.fetchProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


}
