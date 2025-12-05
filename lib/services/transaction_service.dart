// services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class TransactionService {
  static const String baseUrl = 'https://wargakita.canadev.my.id';

  final String token;

  TransactionService(this.token);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  dynamic _handleResponse(http.Response response) {
    print('📡 Response Status: ${response.statusCode}');

    if (response.body.isNotEmpty) {
      print('📡 Response Body: ${response.body}');
    }

    if (response.statusCode.toString().startsWith('2')) {
      if (response.body.isEmpty) {
        throw Exception('Response body is empty');
      }
      return json.decode(response.body); // Return Map, bukan Transaction
    } else if (response.statusCode == 400) {
      final errorBody = response.body.isNotEmpty
          ? json.decode(response.body)
          : {'message': 'Bad Request'};
      throw Exception('Validasi gagal: ${errorBody['message']}');
    } else if (response.statusCode == 500) {
      final errorBody = response.body.isNotEmpty
          ? json.decode(response.body)
          : {'message': 'Internal Server Error'};
      throw Exception('Server error: ${errorBody['message']}');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Silakan login kembali');
    } else if (response.statusCode == 404) {
      throw Exception('Data tidak ditemukan');
    } else {
      throw Exception('Terjadi kesalahan: ${response.statusCode}');
    }
  }

  // GET SUMMARY - FIXED
  Future<TransactionSummary> getSummary({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
  }) async {
    try {
      final Map<String, String> queryParams = {};

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
      }

      // HAPUS userId untuk sementara - menyebabkan error 400
      // if (userId != null && userId.isNotEmpty) {
      //   final parsedUserId = int.tryParse(userId);
      //   if (parsedUserId != null) {
      //     queryParams['userId'] = userId;
      //   }
      // }

      final uri = Uri.parse(
        '$baseUrl/transactions/summary',
      ).replace(queryParameters: queryParams);

      print('🌐 GET Summary: $uri');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TransactionSummary.fromJson(data);
      } else {
        print(
          '❌ GET Summary failed: ${response.statusCode} - ${response.body}',
        );
        // Return default summary daripada throw error
        return TransactionSummary(
          totalIncome: 0,
          totalExpense: 0,
          balance: 0,
          transactionCount: 0,
        );
      }
    } catch (e) {
      print('❌ Error getting summary: $e');
      return TransactionSummary(
        totalIncome: 0,
        totalExpense: 0,
        balance: 0,
        transactionCount: 0,
      );
    }
  }

  // GET TRANSACTIONS - FIXED
  Future<TransactionResponse> getTransactions({
    String? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? createdBy,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page
            .toString(), // Tetap string untuk URL, backend handle conversion
        'limit': limit.toString(),
      };

      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (category != null && category.isNotEmpty)
        queryParams['category'] = category;

      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
      if (endDate != null)
        queryParams['endDate'] = endDate.toIso8601String().split('T')[0];

      // Sekarang bisa kirim userId dan createdBy lagi setelah backend diperbaiki
      if (userId != null && userId.isNotEmpty) {
        final parsedUserId = int.tryParse(userId);
        if (parsedUserId != null) {
          queryParams['userId'] = userId;
        }
      }

      if (createdBy != null && createdBy.isNotEmpty) {
        final parsedCreatedBy = int.tryParse(createdBy);
        if (parsedCreatedBy != null) {
          queryParams['createdBy'] = createdBy;
        }
      }

      final uri = Uri.parse(
        '$baseUrl/transactions',
      ).replace(queryParameters: queryParams);

      print('🌐 GET Transactions: $uri');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TransactionResponse.fromJson(data);
      } else {
        print(
          '❌ GET Transactions failed: ${response.statusCode} - ${response.body}',
        );
        return TransactionResponse(
          transactions: [],
          pagination: Pagination(page: 1, limit: 10, total: 0, pages: 1),
        );
      }
    } catch (e) {
      print('❌ Error getting transactions: $e');
      return TransactionResponse(
        transactions: [],
        pagination: Pagination(page: 1, limit: 10, total: 0, pages: 1),
      );
    }
  }

  // CREATE TRANSACTION - FIXED
  Future<Transaction> createTransaction({
    required double amount,
    required String type,
    required String category,
    required String description,
    required String userId,
    DateTime? date,
  }) async {
    try {
      final parsedUserId = int.tryParse(userId);
      if (parsedUserId == null) {
        throw Exception('User ID tidak valid: $userId');
      }

      // Format date dengan benar untuk Prisma
      final transactionDate = date ?? DateTime.now();
      final formattedDate = transactionDate.toUtc().toIso8601String();

      final transactionData = {
        'amount': amount,
        'type': type.toUpperCase(),
        'category': category,
        'description': description.trim(),
        'userId': parsedUserId,
        'createdBy': parsedUserId,
        'date': formattedDate,
      };

      print('🔍 Transaction Data to Send:');
      print(
        '   - amount: ${transactionData['amount']} (${transactionData['amount'].runtimeType})',
      );
      print('   - type: ${transactionData['type']}');
      print('   - category: ${transactionData['category']}');
      print('   - description: ${transactionData['description']}');
      print(
        '   - userId: ${transactionData['userId']} (${transactionData['userId'].runtimeType})',
      );
      print(
        '   - createdBy: ${transactionData['createdBy']} (${transactionData['createdBy'].runtimeType})',
      );
      print('   - date: ${transactionData['date']}');

      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: _headers,
        body: json.encode(transactionData),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      // Handle response dengan benar
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Transaction.fromJson(data); // Convert Map ke Transaction di sini
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to create transaction: ${errorData['message']}',
        );
      }
    } catch (e) {
      print('❌ Error creating transaction: $e');
      rethrow;
    }
  }

  // UPDATE TRANSACTION - FIXED
  Future<Transaction> updateTransaction({
    required String id,
    double? amount,
    String? type,
    String? category,
    String? description,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (amount != null) updateData['amount'] = amount;
      if (type != null) updateData['type'] = type;
      if (category != null) updateData['category'] = category;
      if (description != null) updateData['description'] = description;

      print('🌐 PUT Update Transaction: $updateData');

      final response = await http.put(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: _headers,
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Transaction.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to update transaction: ${errorData['message']}',
        );
      }
    } catch (e) {
      print('❌ Error updating transaction: $e');
      rethrow;
    }
  }

  // DELETE TRANSACTION
  Future<void> deleteTransaction(String id) async {
    try {
      print('🌐 DELETE Transaction: $id');

      final response = await http.delete(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: _headers,
      );

      _handleResponse(response);
    } catch (e) {
      print('❌ Error deleting transaction: $e');
      rethrow;
    }
  }

  // GET CATEGORIES
  Future<List<String>> getCategories() async {
    try {
      print('🌐 GET Categories');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/categories'),
        headers: _headers,
      );

      final data = _handleResponse(response);

      if (data is List) {
        return data.map((item) => item.toString()).toList();
      } else {
        return ['Iuran', 'Pembangunan', 'Kegiatan', 'Operasional', 'Lainnya'];
      }
    } catch (e) {
      print('❌ Error getting categories: $e');
      return ['Iuran', 'Pembangunan', 'Kegiatan', 'Operasional', 'Lainnya'];
    }
  }

  // GET MONTHLY SUMMARY - FIXED
  Future<TransactionSummary> getMonthlySummary(int month, int year) async {
    try {
      print('🌐 GET Monthly Summary: $month/$year');

      final response = await http.get(
        Uri.parse(
          '$baseUrl/transactions/summary/monthly?month=$month&year=$year',
        ),
        headers: _headers,
      );

      final data = _handleResponse(response);
      return TransactionSummary.fromJson(data);
    } catch (e) {
      print('❌ Error getting monthly summary: $e');
      return TransactionSummary(
        totalIncome: 0,
        totalExpense: 0,
        balance: 0,
        transactionCount: 0,
      );
    }
  }

  // GET RECENT TRANSACTIONS - FIXED
  Future<List<Transaction>> getRecentTransactions({int limit = 10}) async {
    try {
      print('🌐 GET Recent Transactions: limit=$limit');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/recent?limit=$limit'),
        headers: _headers,
      );

      final data = _handleResponse(response);

      if (data is List) {
        return data.map((item) => Transaction.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('❌ Error getting recent transactions: $e');
      return [];
    }
  }

  // GET USER TRANSACTIONS
  Future<TransactionResponse> getUserTransactions({
    required String userId,
    String? type,
    int page = 1,
    int limit = 10,
  }) async {
    return getTransactions(
      userId: userId,
      type: type,
      page: page,
      limit: limit,
    );
  }

  // services/transaction_service.dart - Tambahkan debug methods

  Future<dynamic> getDebugSummary() async {
    try {
      print('🔍 GET Debug Summary');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/debug/summary'),
        headers: _headers,
      );

      print('📡 Debug Summary Response: ${response.statusCode}');
      print('📡 Debug Summary Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get debug summary: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting debug summary: $e');
      rethrow;
    }
  }

  Future<void> updateSummaryManually() async {
    try {
      final now = DateTime.now();
      print('🔧 Manually updating summary for ${now.month}/${now.year}');

      final response = await http.post(
        Uri.parse('$baseUrl/transactions/debug/update-summary'),
        headers: _headers,
        body: json.encode({'month': now.month, 'year': now.year}),
      );

      print('📡 Manual Update Response: ${response.statusCode}');
      print('📡 Manual Update Body: ${response.body}');
    } catch (e) {
      print('❌ Error in manual update: $e');
    }
  }
  Future<TransactionSummary> getSummaryFromDebug() async {
    try {
      print('🌐 GET Summary from Debug Endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/debug/summary'),
        headers: _headers,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        final transactionSummary = data['transactionSummary'];

        return TransactionSummary(
          totalIncome: (transactionSummary['totalIncome'] as num).toDouble(),
          totalExpense: (transactionSummary['totalExpense'] as num).toDouble(),
          balance: (transactionSummary['balance'] as num).toDouble(),
          transactionCount: transactionSummary['transactionCount'] ?? 0,
        );
      } else {
        throw Exception('Failed to get debug summary: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting debug summary: $e');
      rethrow;
    }
  }
}
