import 'package:flutter/foundation.dart';
import './models/models.dart';

/// Mock transaction repository for unsupported platforms (Linux, Windows desktop)
class MockTransactions {
  MockTransactions();

  // Fetch mock transactions for demo purposes
  Future<List<TransactionsModel>> fetchTransactions() async {
    if (kDebugMode) {
      print('MockTransactions: fetchTransactions called (returning mock data)');
    }

    // Return mock transactions
    return [
      TransactionsModel(
        documentId: 'doc1',
        transactionId: 'TXN001',
        requestId: 'REQ001',
        name: 'Plastic Bottles Collection',
        value: 45.50,
        note: 'Collection of 50kg plastic bottles',
        rating: 4.5,
        feedback: 'Great service, very efficient!',
        status: 'completed',
        pricePerKg: 0.91,
        weight: 50.0,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TransactionsModel(
        documentId: 'doc2',
        transactionId: 'TXN002',
        requestId: 'REQ002',
        name: 'Paper Waste Recycling',
        value: 32.75,
        note: 'Mixed paper waste - 35kg',
        rating: 4.0,
        feedback: 'Good collection, on time',
        status: 'completed',
        pricePerKg: 0.935,
        weight: 35.0,
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TransactionsModel(
        documentId: 'doc3',
        transactionId: 'TXN003',
        requestId: 'REQ003',
        name: 'Metal Scrap Pickup',
        value: 89.00,
        note: 'Aluminum and steel scraps - 25kg',
        rating: 5.0,
        feedback: 'Excellent! Will use again',
        status: 'completed',
        pricePerKg: 3.56,
        weight: 25.0,
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
      ),
      TransactionsModel(
        documentId: 'doc4',
        transactionId: 'TXN004',
        requestId: 'REQ004',
        name: 'Glass Bottles Collection',
        value: 18.50,
        note: 'Clear glass bottles - 20kg',
        rating: 0.0,
        feedback: '',
        status: 'pending',
        pricePerKg: 0.925,
        weight: 20.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      TransactionsModel(
        documentId: 'doc5',
        transactionId: 'TXN005',
        requestId: 'REQ005',
        name: 'Organic Waste Compost',
        value: 28.00,
        note: 'Organic kitchen waste - 40kg',
        rating: 4.8,
        feedback: 'Very satisfied with the service',
        status: 'completed',
        pricePerKg: 0.70,
        weight: 40.0,
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
      ),
      TransactionsModel(
        documentId: 'doc6',
        transactionId: 'TXN006',
        requestId: 'REQ006',
        name: 'Electronics Recycling',
        value: 125.00,
        note: 'Old computer parts and cables - 15kg',
        rating: 0.0,
        feedback: '',
        status: 'processing',
        pricePerKg: 8.33,
        weight: 15.0,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Save a transaction (no-op for mock)
  Future<void> saveTransaction(TransactionsModel transaction) async {
    if (kDebugMode) {
      print(
          'MockTransactions: saveTransaction called (no-op on this platform)');
    }
  }

  // Update transaction (no-op for mock)
  Future<void> updateTransaction(
    String transactionId, {
    String? feedback,
    double? rating,
    String? status,
  }) async {
    if (kDebugMode) {
      print(
          'MockTransactions: updateTransaction called (no-op on this platform)');
    }
  }
}
