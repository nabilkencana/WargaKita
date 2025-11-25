// models/transaction_model.dart
import 'user_model.dart';

class Transaction {
  final String id;
  final double amount;
  final String type; // 'INCOME' atau 'EXPENSE'
  final String category;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final String userId;
  final String createdBy;
  final User? user;
  final User? createdByUser;
  final Payment? payment;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.date,
    required this.createdAt,
    required this.userId,
    required this.createdBy,
    this.user,
    this.createdByUser,
    this.payment,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing Transaction from JSON: $json');

    // Handle ID yang bisa berupa String atau int
    final id = json['id']?.toString() ?? 'unknown_id';

    // Handle amount yang bisa berupa double, int, atau String
    final amount = json['amount'] != null
        ? (json['amount'] is String
              ? double.tryParse(json['amount']) ?? 0.0
              : (json['amount'] as num).toDouble())
        : 0.0;

    // Handle type (INCOME/EXPENSE)
    final type = json['type']?.toString() ?? 'EXPENSE';

    // Handle category dengan fallback
    final category = json['category']?.toString() ?? 'Umum';

    // Handle description
    final description = json['description']?.toString() ?? '';

    // Handle dates
    final date = json['date'] != null
        ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
        : DateTime.now();

    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : DateTime.now();

    // Handle user IDs
    final userId = json['userId']?.toString() ?? '';
    final createdBy = json['createdBy']?.toString() ?? '';

    // Handle nested user objects
    final user = json['user'] != null ? User.fromJson(json['user']) : null;
    final createdByUser = json['createdByUser'] != null
        ? User.fromJson(json['createdByUser'])
        : null;

    // Handle payment
    final payment = json['payment'] != null
        ? Payment.fromJson(json['payment'])
        : null;

    print('✅ Parsed Transaction:');
    print('   ID: $id');
    print('   Amount: $amount');
    print('   Type: $type');
    print('   Category: $category');
    print('   Description: $description');

    return Transaction(
      id: id,
      amount: amount,
      type: type,
      category: category,
      description: description,
      date: date,
      createdAt: createdAt,
      userId: userId,
      createdBy: createdBy,
      user: user,
      createdByUser: createdByUser,
      payment: payment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'userId': userId,
      'createdBy': createdBy,
    };
  }

  // Helper method untuk check jika transaction adalah pemasukan
  bool get isIncome => type.toUpperCase() == 'INCOME';

  // Helper method untuk check jika transaction adalah pengeluaran
  bool get isExpense => type.toUpperCase() == 'EXPENSE';

  // Helper method untuk format amount dengan simbol +/-
  String get formattedAmount {
    final symbol = isIncome ? '+' : '-';
    return '$symbol Rp ${amount.toStringAsFixed(0)}';
  }
}

class Payment {
  final String id;
  final String status;
  final String? paymentMethod;
  final String? referenceNumber;

  Payment({
    required this.id,
    required this.status,
    this.paymentMethod,
    this.referenceNumber,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      paymentMethod: json['paymentMethod']?.toString(),
      referenceNumber: json['referenceNumber']?.toString(),
    );
  }
}

class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int transactionCount;

  TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.transactionCount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['totalExpense'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class TransactionResponse {
  final List<Transaction> transactions;
  final Pagination pagination;

  TransactionResponse({required this.transactions, required this.pagination});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    final transactions = (json['transactions'] as List? ?? [])
        .map((item) => Transaction.fromJson(item))
        .toList();

    final pagination = Pagination.fromJson(json['pagination'] ?? {});

    return TransactionResponse(
      transactions: transactions,
      pagination: pagination,
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 1,
    );
  }
}
