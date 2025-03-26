import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> fetchProducts({int limit = 10, int skip = 0}) async {
    try {
      print('Fetching products with limit: $limit, skip: $skip');
      final response = await http.get(
        Uri.parse('$baseUrl/products?limit=$limit&skip=$skip'),
      );

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debug the response structure
        print('Total products: ${data['total']}');
        print('Products count: ${(data['products'] as List).length}');

        final List<dynamic> productsJson = data['products'];
        final List<Product> products = [];

        for (var productJson in productsJson) {
          try {
            final product = Product.fromJson(productJson);
            products.add(product);
          } catch (e) {
            print('Error parsing product: $e');
            print('Product data: $productJson');
          }
        }

        return {
          'products': products,
          'total': data['total'] as int? ?? 0,
          'skip': data['skip'] as int? ?? 0,
          'limit': data['limit'] as int? ?? 10,
        };
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }
}