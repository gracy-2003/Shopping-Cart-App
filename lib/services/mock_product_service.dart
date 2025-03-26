import '../models/product.dart';

class MockProductService {
  Future<Map<String, dynamic>> fetchProducts({int limit = 10, int skip = 0}) async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Product> products = List.generate(
      10,
          (index) => Product(
        id: index + 1,
        title: 'Product ${index + 1}',
        description: 'This is a description for product ${index + 1}',
        price: 99.99,
        discountPercentage: 15.0,
        rating: 4.5,
        stock: 50,
        brand: 'Brand Name',
        category: 'Electronics',
        thumbnail: 'https://via.placeholder.com/150',
        images: [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150',
        ],
      ),
    );

    return {
      'products': products,
      'total': 100,
      'skip': skip,
      'limit': limit,
    };
  }
}