import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';

/// Mock cart repository for unsupported platforms (Linux, Windows desktop)
class MockCartRepo extends ChangeNotifier {
  MockCartRepo();

  Future<void> addCartItem(
      String userId,
      Color color,
      int amount,
      String productId,
      double price,
      String productname,
      String imageUrl,
      double unitPrice) async {
    if (kDebugMode) {
      print('MockCartRepo: addCartItem called (no-op on this platform)');
    }
  }

  Stream<double> getTotalPrice(String userId) {
    // Return mock total price for demo purposes
    return Stream.value(44.48); // 31.98 + 12.50
  }

  Future<void> removeCartItem(String userId, String itemId) async {
    if (kDebugMode) {
      print('MockCartRepo: removeCartItem called (no-op on this platform)');
    }
  }

  Future<void> updateCartItem(
      String userId, CartItem item, String itemId) async {
    if (kDebugMode) {
      print('MockCartRepo: updateCartItem called (no-op on this platform)');
    }
  }

  Stream<List<CartItem>> getCartItems(String userId) {
    // Return mock cart items for demo purposes
    return Stream.value([
      CartItem(
        id: '1',
        productId: '1',
        quantity: 2,
        color: Colors.blue,
        price: 31.98,
        name: 'Recycled Plastic Bottles',
        imageUrl: 'https://via.placeholder.com/300x200?text=Plastic+Bottles',
        unitPrice: 15.99,
        date: Timestamp.fromDate(DateTime.now()),
      ),
      CartItem(
        id: '2',
        productId: '2',
        quantity: 1,
        color: Colors.green,
        price: 12.50,
        name: 'Eco-Friendly Paper Products',
        imageUrl: 'https://via.placeholder.com/300x200?text=Paper+Products',
        unitPrice: 12.50,
        date: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
      ),
    ]);
  }

  Future<void> addSingleItem(
      String userId, String itemId, double unitPrice, int quantity) async {
    if (kDebugMode) {
      print('MockCartRepo: addSingleItem called (no-op on this platform)');
    }
  }

  Future<void> removeSingleItem(
      String userId, String itemId, double unitPrice, int quantity) async {
    if (kDebugMode) {
      print('MockCartRepo: removeSingleItem called (no-op on this platform)');
    }
  }

  Stream<int> getCartItemCount(String userId) {
    return Stream.value(0);
  }
}
