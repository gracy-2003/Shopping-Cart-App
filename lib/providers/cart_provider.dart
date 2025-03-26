import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: state[index].quantity + 1),
        ...state.sublist(index + 1),
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void incrementQuantity(int productId) {
    final index = state.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: state[index].quantity + 1),
        ...state.sublist(index + 1),
      ];
    }
  }

  void decrementQuantity(int productId) {
    final index = state.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      final currentQuantity = state[index].quantity;

      if (currentQuantity > 1) {
        state = [
          ...state.sublist(0, index),
          state[index].copyWith(quantity: currentQuantity - 1),
          ...state.sublist(index + 1),
        ];
      } else {
        removeFromCart(productId);
      }
    }
  }

  double get totalPrice {
    return state.fold(0, (total, item) => total + item.totalPrice);
  }

  int get itemCount {
    return state.fold(0, (total, item) => total + item.quantity);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.quantity);
});