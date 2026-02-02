import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  bool addToCart(Product product) {
    if (product.stock > 0) {
      // Check if product already in cart
      var existingItem = cartItems.firstWhereOrNull(
        (item) => item.product.id == product.id,
      );
      if (existingItem != null) {
        existingItem.quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
      return true;
    }
    return false;
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void clearCart() {
    cartItems.clear();
  }
}
