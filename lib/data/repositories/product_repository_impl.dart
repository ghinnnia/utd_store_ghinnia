import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/dio_client.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient dioClient;
  final String nim = '20123046';
  final int lastDigit = 6;

  ProductRepositoryImpl({required this.dioClient});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await dioClient.dio.get('/products');
      final List<dynamic> data = response.data;

      return data.map((json) {
        final product = ProductModel.fromJson(json);
        String modifiedTitle = product.title;
        if (lastDigit % 2 == 0) {
          modifiedTitle = '$modifiedTitle [Promo Ongkir]';
        }
        return Product(
          id: product.id,
          title: modifiedTitle,
          price: product.price,
          description: product.description,
          image: product.image,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
// NIM discount logic.