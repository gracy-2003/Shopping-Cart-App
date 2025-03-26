import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

class ProductsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ProductService _productService;
  bool _isLoading = false;

  ProductsNotifier(this._productService) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts({int limit = 10, int skip = 0}) async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      state = const AsyncValue.loading();
      final data = await _productService.fetchProducts(limit: limit, skip: skip);
      if (mounted) {
        state = AsyncValue.data(data);
      }
    } catch (e, stackTrace) {
      print('Error in loadProducts: $e');
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !state.hasValue) return;

    final currentData = state.value!;
    final currentSkip = currentData['skip'] as int;
    final currentLimit = currentData['limit'] as int;
    final total = currentData['total'] as int;

    if (currentSkip + currentLimit < total) {
      _isLoading = true;
      try {
        final newData = await _productService.fetchProducts(
          limit: currentLimit,
          skip: currentSkip + currentLimit,
        );

        if (mounted) {
          final List<Product> currentProducts = currentData['products'];
          final List<Product> newProducts = newData['products'];

          state = AsyncValue.data({
            'products': [...currentProducts, ...newProducts],
            'total': newData['total'],
            'skip': newData['skip'],
            'limit': newData['limit'],
          });
        }
      } catch (e, stackTrace) {
        print('Error in loadNextPage: $e');
      } finally {
        _isLoading = false;
      }
    }
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductsNotifier(productService);
});