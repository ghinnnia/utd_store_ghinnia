import 'package:utd_store_ghinnia/domain/entities/product.dart';

import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}