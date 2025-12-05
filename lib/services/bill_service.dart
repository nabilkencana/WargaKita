// services/bill_service.dart - VERSI DIPERBAIKI (tetap sama seperti sebelumnya)
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bill_model.dart';

class BillService {
  static const String baseUrl = 'https://wargakita.canadev.my.id';

  final String token;

  BillService(this.token);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Future<BillResponse> getUserBills({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(
        '$baseUrl/bills/my-bills',
      ).replace(queryParameters: queryParams);

      print('🌐 GET User Bills: $uri');

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return BillResponse.fromJson(data);
      } else {
        throw Exception('Failed to load bills: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting bills: $e');
      rethrow;
    }
  }

  // services/bill_service.dart - VERSI SESUAI BACKEND
  Future<Bill> payBill(
    String billId, {
    String? paymentMethod,
    String? qrData,
  }) async {
    try {
      // Format request sesuai dengan yang diharapkan backend
      final Map<String, dynamic> requestBody = {
        'method':
            paymentMethod ??
            'QRIS', // Field harus 'method' bukan 'paymentMethod'
      };

      // Opsional: tambahkan receiptImage jika ada qrData
      if (qrData != null) {
        requestBody['receiptImage'] = 'https://qris.example.com/$qrData';
      }

      // Opsional: tambahkan paidDate
      requestBody['paidDate'] = DateTime.now().toIso8601String();

      print('🔄 Pay Bill Request (Backend Format):');
      print('📦 Bill ID: $billId');
      print('💳 Method: ${requestBody['method']}');
      print('📝 Request Body: $requestBody');

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pay'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        print('❌ Payment failed with status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        throw Exception(
          'Failed to pay bill: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error paying bill: $e');
      rethrow;
    }
  }

  // Method untuk testing dengan format minimal
  Future<Bill> payBillMinimal(String billId, String paymentMethod) async {
    try {
      // Format minimal yang diharapkan backend
      final Map<String, dynamic> requestBody = {'method': paymentMethod};

      print('🔄 Minimal Pay Bill Request:');
      print('📦 Bill ID: $billId');
      print('💳 Method: $paymentMethod');

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pay'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      print('📡 Minimal Response Status: ${response.statusCode}');
      print('📨 Minimal Response Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception('Failed to pay bill: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in minimal pay bill: $e');
      rethrow;
    }
  }

  // Coba method dengan empty body
  Future<Bill> payBillEmptyBody(String billId) async {
    try {
      print('🔄 Empty Body Pay Bill Request for: $billId');

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pay'),
        headers: _headers,
        body: json.encode({}), // Empty object
      );

      print('📡 Empty Body Response Status: ${response.statusCode}');
      print('📨 Empty Body Response Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception('Failed to pay bill: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in empty body pay bill: $e');
      rethrow;
    }
  }

  // Coba method tanpa body sama sekali
  Future<Bill> payBillNoBody(String billId) async {
    try {
      print('🔄 No Body Pay Bill Request for: $billId');

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pay'),
        headers: _headers,
        // No body at all
      );

      print('📡 No Body Response Status: ${response.statusCode}');
      print('📨 No Body Response Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception('Failed to pay bill: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in no body pay bill: $e');
      rethrow;
    }
  }

  // Alternative method without parameters (for testing)
  Future<Bill> payBillSimple(String billId) async {
    try {
      print('🔄 Simple Pay Bill Request for: $billId');

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pay'),
        headers: _headers,
      );

      print('📡 Simple Response Status: ${response.statusCode}');
      print('📨 Simple Response Body: ${response.body}');

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception('Failed to pay bill: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error in simple pay bill: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBillSummary() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bills/summary'),
        headers: _headers,
      );

      if (response.statusCode.toString().startsWith('2')) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load bill summary: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting bill summary: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateQRIS(String billId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/generate-qris'),
        headers: _headers,
      );

      if (response.statusCode.toString().startsWith('2')) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate QRIS: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error generating QRIS: $e');
      rethrow;
    }
  }

  // ✅ METHOD BARU: Create pending payment
  Future<Bill> createPendingPayment(
    String billId, {
    required String method,
    String? receiptImage,
    String? qrData,
  }) async {
    try {
      final requestBody = {
        'method': method,
        if (receiptImage != null) 'receiptImage': receiptImage,
        if (qrData != null) 'qrData': qrData,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/bills/$billId/pending-payment'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception(
          'Failed to create pending payment: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error creating pending payment: $e');
      rethrow;
    }
  }

  // ✅ METHOD BARU: Check payment status
  Future<Bill> getBillStatus(String billId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bills/$billId'),
        headers: _headers,
      );

      if (response.statusCode.toString().startsWith('2')) {
        final data = json.decode(response.body);
        return Bill.fromJson(data);
      } else {
        throw Exception('Failed to get bill status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting bill status: $e');
      rethrow;
    }
  }
}
