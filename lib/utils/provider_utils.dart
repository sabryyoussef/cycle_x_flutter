import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:products_repository/products_repository.dart';

/// Utility class to get the appropriate providers based on platform
class ProviderUtils {
  /// Gets the appropriate user repository (MockUserRepo for Linux/Windows, FirebaseUserRepo for others)
  static UserRepository getUserRepository(BuildContext context) {
    try {
      // First try to get MockUserRepo (for Linux/Windows)
      return Provider.of<MockUserRepo>(context, listen: false);
    } catch (e) {
      // If that fails, try FirebaseUserRepo (for other platforms)
      return Provider.of<FirebaseUserRepo>(context, listen: false);
    }
  }

  /// Gets the appropriate product service (MockProductService for Linux/Windows, ProductService for others)
  static dynamic getProductService(BuildContext context) {
    try {
      // First try to get MockProductService (for Linux/Windows)
      return Provider.of<MockProductService>(context, listen: false);
    } catch (e) {
      // If that fails, try ProductService (for other platforms)
      return Provider.of<ProductService>(context, listen: false);
    }
  }
}
