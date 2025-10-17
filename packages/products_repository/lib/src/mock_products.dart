import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './models/models.dart';

/// Mock product service for unsupported platforms (Linux, Windows desktop)
class MockProductService extends ChangeNotifier {
  MockProductService();

  // Fetch a single product by its ID
  Future<ProductModel> getProductById(String productId) async {
    if (kDebugMode) {
      print(
          'MockProductService: getProductById called (returning empty product)');
    }
    return ProductModel.empty;
  }

  // Fetch all products with mock data
  Future<List<ProductModel>> getAllProducts(int sortType) async {
    if (kDebugMode) {
      print('MockProductService: getAllProducts called (returning mock data)');
    }

    // Return mock products for demo purposes
    return [
      ProductModel(
        id: '1',
        name: 'Recycled Plastic Bottles',
        description: 'High-quality recycled plastic bottles for various uses',
        longDescription:
            'These premium recycled plastic bottles are perfect for storing liquids, gardening, or creative DIY projects. Made from 100% recycled materials.',
        price: 15.99,
        imageUrls: ['https://via.placeholder.com/300x200?text=Plastic+Bottles'],
        rating: 4.5,
        ratingCount: 23,
        colors: [Colors.blue, Colors.green],
      ),
      ProductModel(
        id: '2',
        name: 'Eco-Friendly Paper Products',
        description: 'Sustainable paper products made from recycled materials',
        longDescription:
            'High-quality paper products including notebooks, stationery, and packaging materials, all made from recycled paper.',
        price: 12.50,
        imageUrls: ['https://via.placeholder.com/300x200?text=Paper+Products'],
        rating: 4.2,
        ratingCount: 18,
        colors: [Colors.brown, Colors.white],
      ),
      ProductModel(
        id: '3',
        name: 'Metal Scrap Collection',
        description: 'Various metal scraps ready for recycling',
        longDescription:
            'Assorted metal scraps including aluminum, steel, and copper pieces, perfect for recycling or craft projects.',
        price: 8.75,
        imageUrls: ['https://via.placeholder.com/300x200?text=Metal+Scrap'],
        rating: 4.0,
        ratingCount: 12,
        colors: [Colors.grey, Colors.amber],
      ),
      ProductModel(
        id: '4',
        name: 'Glass Recycling Kit',
        description: 'Complete kit for glass recycling at home',
        longDescription:
            'Everything you need to start recycling glass at home, including sorting containers, labels, and instructions.',
        price: 25.00,
        imageUrls: ['https://via.placeholder.com/300x200?text=Glass+Kit'],
        rating: 4.8,
        ratingCount: 31,
        colors: [Colors.cyan, Colors.blue],
      ),
      ProductModel(
        id: '5',
        name: 'Organic Compost',
        description: 'Premium organic compost made from food waste',
        longDescription:
            'Rich, nutrient-dense compost created from organic food waste, perfect for gardening and plant care.',
        price: 18.99,
        imageUrls: ['https://via.placeholder.com/300x200?text=Compost'],
        rating: 4.6,
        ratingCount: 27,
        colors: [Colors.green, Colors.brown],
      ),
    ];
  }
}
