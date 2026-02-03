import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/customer.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var selectedCustomer = Rx<Customer?>(null);

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

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  void setCustomer(Customer customer) {
    selectedCustomer.value = customer;
  }

  void calculateTotal() {
    // This method can be used to recalculate total if needed
  }

  double get totalAmount {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void clearCart() {
    cartItems.clear();
  }
}
