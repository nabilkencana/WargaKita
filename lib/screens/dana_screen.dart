// dana_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class DanaScreen extends StatefulWidget {
  final User user;

  const DanaScreen({super.key, required this.user});

  @override
  State<DanaScreen> createState() => _DanaScreenState();
}

class _DanaScreenState extends State<DanaScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Pemasukan', 'Pengeluaran'];

  TransactionService? _transactionService;
  TransactionSummary? _summary;
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeService();
    _loadData();
  }

  void _initializeService() {
    try {
      // Ganti dengan token yang sesungguhnya
      final token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoibmFiaWxrZW5jYW5hMjBAZ21haWwuY29tIiwicm9sZSI6IlNVUEVSX0FETUlOIiwibmFtZSI6Ik5hYmlsIEFkbWluIiwiaWF0IjoxNzY0MDc5OTEyLCJleHAiOjE3NjQxNjYzMTJ9.HyAUvOl0TRV0WyCdzmt6UV2sK2DQS9ZU2xsOCJtzykA';

      // Pastikan user ID valid
      if (widget.user.id.isEmpty || widget.user.id == 'unknown_id') {
        throw Exception('User ID tidak valid');
      }

      _transactionService = TransactionService(token);
    } catch (e) {
      print('❌ Error initializing service: $e');
      setState(() {
        _errorMessage = 'Gagal menginisialisasi service: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Method 1: Coba get summary dari debug endpoint (yang work)
      try {
        final debugSummary = await _transactionService!.getSummaryFromDebug();
        setState(() {
          _summary = debugSummary;
        });
        print('✅ Got summary from debug endpoint: ${debugSummary.balance}');
      } catch (e) {
        print('⚠️  Cannot get debug summary: $e');
        // Fallback ke getSummary biasa
        final normalSummary = await _transactionService!.getSummary();
        setState(() {
          _summary = normalSummary;
        });
      }

      // Method 2: Coba get transactions (tapi handle error gracefully)
      try {
        final transactionsResponse = await _transactionService!.getTransactions(
          limit: 50,
        );
        setState(() {
          _transactions = transactionsResponse.transactions;
        });
        print('✅ Got ${_transactions.length} transactions');
      } catch (e) {
        print('⚠️  Cannot get transactions: $e');
        // Transactions optional, bisa kosong
        setState(() {
          _transactions = [];
        });
      }

      setState(() {
        _isLoading = false;
      });

      // Debug final state
      print('🎯 FINAL STATE:');
      print('   - Summary Balance: ${_summary?.balance}');
      print('   - Transactions Count: ${_transactions.length}');
      print('   - Real-time Balance: ${_realTimeSummary.balance}');
    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  // Filter transactions berdasarkan pilihan
  List<Transaction> get _filteredTransactions {
    if (_selectedFilter == 0) return _transactions;
    if (_selectedFilter == 1) {
      return _transactions.where((t) => t.isIncome).toList();
    }
    return _transactions.where((t) => t.isExpense).toList();
  }

  // Di DanaScreen - Test dengan debug endpoints
  // Di _DanaScreenState - Tambahkan debug yang lebih detail

  Future<void> _debugFinancialSummary() async {
    try {
      print('🔍 COMPREHENSIVE FINANCIAL DEBUG');

      // 1. Get ALL transactions untuk melihat data sebenarnya
      final allTransactions = await _transactionService!.getTransactions(
        limit: 100,
      );
      print(
        '📋 ALL TRANSACTIONS (${allTransactions.transactions.length} items):',
      );

      double manualIncome = 0;
      double manualExpense = 0;

      for (final transaction in allTransactions.transactions) {
        print(
          '   - ${transaction.description}: ${transaction.amount} (${transaction.type}) - ${transaction.date}',
        );
        if (transaction.isIncome) {
          manualIncome += transaction.amount;
        } else {
          manualExpense += transaction.amount;
        }
      }

      print('🧮 MANUAL CALCULATION:');
      print('   - Income: $manualIncome');
      print('   - Expense: $manualExpense');
      print('   - Balance: ${manualIncome - manualExpense}');

      // 2. Get summary dari API
      final apiSummary = await _transactionService!.getSummary();
      print('📊 API SUMMARY:');
      print('   - Income: ${apiSummary.totalIncome}');
      print('   - Expense: ${apiSummary.totalExpense}');
      print('   - Balance: ${apiSummary.balance}');

      // 3. Get debug summary dari backend
      try {
        final debugSummary = await _transactionService!.getDebugSummary();
        print('🐛 BACKEND DEBUG SUMMARY:');
        print(
          '   - Transaction Summary: ${debugSummary['transactionSummary']}',
        );
        print('   - Financial Summary: ${debugSummary['financialSummary']}');
        print('   - Match: ${debugSummary['match']}');
      } catch (e) {
        print('⚠️  Debug endpoint not available: $e');
      }

      // 4. Check jika ada perbedaan
      if (apiSummary.totalIncome != manualIncome ||
          apiSummary.totalExpense != manualExpense) {
        print('🚨 DATA MISMATCH DETECTED!');
        print(
          '   - Manual vs API Income: $manualIncome vs ${apiSummary.totalIncome}',
        );
        print(
          '   - Manual vs API Expense: $manualExpense vs ${apiSummary.totalExpense}',
        );
      }
    } catch (e) {
      print('❌ Debug failed: $e');
    }
  }

  TransactionSummary get _realTimeSummary {
    double totalIncome = 0;
    double totalExpense = 0;
    int transactionCount = _transactions.length;

    for (final transaction in _transactions) {
      if (transaction.type.toUpperCase() == 'INCOME') {
        totalIncome += transaction.amount;
      } else if (transaction.type.toUpperCase() == 'EXPENSE') {
        totalExpense += transaction.amount;
      }
    }

    final balance = totalIncome - totalExpense;

    print('🔄 REAL-TIME CALCULATION:');
    print('   - Income: $totalIncome');
    print('   - Expense: $totalExpense');
    print('   - Balance: $balance');
    print('   - Count: $transactionCount');

    return TransactionSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: balance,
      transactionCount: transactionCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Dana Community',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 24),
            onPressed: () => _showTransactionHistory(context),
            tooltip: 'Riwayat Lengkap',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            onPressed: () => _showMoreOptions(context),
            tooltip: 'Lainnya',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _errorMessage.isNotEmpty
          ? _buildErrorWidget()
          : _buildMainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickTransactionMenu(context),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data...'),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    // Prioritaskan data yang available
    final double displayBalance = _transactions.isNotEmpty
        ? _realTimeSummary.balance
        : (_summary?.balance ?? 0);

    final double displayIncome = _transactions.isNotEmpty
        ? _realTimeSummary.totalIncome
        : (_summary?.totalIncome ?? 0);

    final double displayExpense = _transactions.isNotEmpty
        ? _realTimeSummary.totalExpense
        : (_summary?.totalExpense ?? 0);

    String dataSource = 'Kalkulasi Real-time';
    if (_transactions.isEmpty && _summary != null) {
      dataSource = 'API Summary';
    } else if (_transactions.isNotEmpty) {
      dataSource = 'Data Langsung';
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          // Header dengan Saldo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Saldo Utama
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Saldo',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${_formatCurrency(displayBalance)}',
                      style: TextStyle(
                        color: displayBalance >= 0
                            ? Colors.white
                            : Colors.red.shade200,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update: ${_getCurrentDate()}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    // Tampilkan sumber data
                    Text(
                      dataSource,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Ringkasan Keuangan
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      _buildFinanceItem(
                        'Pemasukan',
                        'Rp ${_formatCurrency(displayIncome)}',
                        Icons.arrow_downward,
                        Colors.green.shade100,
                        Colors.green,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _buildFinanceItem(
                        'Pengeluaran',
                        'Rp ${_formatCurrency(displayExpense)}',
                        Icons.arrow_upward,
                        Colors.red.shade100,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tampilkan warning jika ada masalah data
          if (_transactions.isEmpty && _summary?.balance == 0)
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange.shade600, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Data transaksi sedang tidak dapat diakses. Saldo ditampilkan dari summary terakhir.',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Quick Actions
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  Icons.add,
                  'Tambah',
                  Colors.green.shade50,
                  Colors.green,
                  () => _showAddIncomeDialog(context),
                ),
                _buildActionButton(
                  Icons.remove,
                  'Bayar',
                  Colors.red.shade50,
                  Colors.red,
                  () => _showPaymentDialog(context),
                ),
                _buildActionButton(
                  Icons.bar_chart,
                  'Refresh',
                  Colors.blue.shade50,
                  Colors.blue,
                  _refreshData,
                ),
                _buildActionButton(
                  Icons.bug_report,
                  'Debug',
                  Colors.orange.shade50,
                  Colors.orange,
                  _debugFinancialSummary,
                ),
              ],
            ),
          ),

          // Filter dan Riwayat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 16,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _filters[_selectedFilter],
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_filters[index]),
                          selected: _selectedFilter == index,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = index;
                            });
                          },
                          selectedColor: Colors.blue.shade100,
                          checkmarkColor: Colors.blue.shade600,
                          labelStyle: TextStyle(
                            color: _selectedFilter == index
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                            fontWeight: _selectedFilter == index
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // List Transaksi
          Expanded(
            child: _transactions.isNotEmpty
                ? _buildTransactionList()
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'Tidak ada data transaksi',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Transaksi akan muncul di sini ketika tersedia',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _refreshData, child: Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildFinanceItem(
    String title,
    String amount,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: IconButton(
            icon: Icon(icon, color: iconColor),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Pastikan juga _buildTransactionItem ada (seharusnya sudah ada dari kode sebelumnya)
  Widget _buildTransactionItem(Transaction transaction) {
    final icon = _getTransactionIcon(transaction.category);
    final category = transaction.category;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.isIncome
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: transaction.isIncome
                  ? Colors.green.shade600
                  : Colors.red.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_formatDate(transaction.date)} • ${_formatTime(transaction.date)}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: TextStyle(
                  color: transaction.isIncome
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.isIncome ? 'Pemasukan' : 'Pengeluaran',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tambahkan method ini jika belum ada
  String _formatCurrency(double amount) {
    // Handle negative numbers
    final absoluteAmount = amount.abs();
    final formatted = absoluteAmount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return amount < 0 ? '-$formatted' : formatted;
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  // Helper methods yang diperlukan
  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }

  IconData _getTransactionIcon(String category) {
    switch (category.toLowerCase()) {
      case 'iuran':
        return Icons.account_balance_wallet;
      case 'pembangunan':
        return Icons.construction;
      case 'kegiatan':
        return Icons.celebration;
      case 'operasional':
        return Icons.shopping_cart;
      case 'donasi':
        return Icons.volunteer_activism;
      default:
        return Icons.receipt;
    }
  }

  // === FUNGSI DIALOG DAN ACTION ===

  void _showQuickTransactionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaksi Cepat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    Icons.add_circle,
                    'Pemasukan',
                    Colors.green,
                    () {
                      Navigator.pop(context);
                      _showAddIncomeDialog(context);
                    },
                  ),
                  _buildQuickAction(
                    Icons.remove_circle,
                    'Pengeluaran',
                    Colors.red,
                    () {
                      Navigator.pop(context);
                      _showPaymentDialog(context);
                    },
                  ),
                  _buildQuickAction(Icons.receipt, 'Laporan', Colors.blue, () {
                    Navigator.pop(context);
                    _showReportDialog(context);
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: Icon(icon, color: color, size: 30),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAddIncomeDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategory = 'Iuran';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_circle, color: Colors.green.shade600),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tambah Pemasukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                hintText: 'Contoh: 50000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Colors.green.shade600,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Keterangan',
                hintText: 'Contoh: Iuran Bulan Desember',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.description,
                  color: Colors.green.shade600,
                ),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.category, color: Colors.green.shade600),
              ),
              items: ['Iuran', 'Donasi', 'Sumbangan', 'Lainnya']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amountText = amountController.text.trim();
              final descriptionText = descriptionController.text.trim();

              // Validasi input
              if (amountText.isEmpty) {
                _showErrorSnackbar(context, 'Harap masukkan jumlah');
                return;
              }

              if (descriptionText.isEmpty) {
                _showErrorSnackbar(context, 'Harap masukkan keterangan');
                return;
              }

              final amount = double.tryParse(amountText);
              if (amount == null || amount <= 0) {
                _showErrorSnackbar(context, 'Jumlah tidak valid');
                return;
              }

              try {
                setState(() {
                  _isLoading = true;
                });

                // Tutup dialog dulu
                Navigator.pop(context);

                await _transactionService!.createTransaction(
                  amount: amount,
                  type: 'INCOME',
                  category: selectedCategory!,
                  description: descriptionText,
                  userId: widget.user.id,
                );

                _showSuccessSnackbar(context, 'Pemasukan berhasil ditambahkan');

                // Refresh data
                await _refreshData();
              } catch (e) {
                _showErrorSnackbar(context, 'Gagal menambah pemasukan: $e');
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategory = 'Operasional';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.remove_circle, color: Colors.red.shade600),
            ),
            const SizedBox(width: 12),
            const Text(
              'Bayar Pengeluaran',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Colors.red.shade600,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.description, color: Colors.red.shade600),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.category, color: Colors.red.shade600),
              ),
              items: ['Operasional', 'Pembangunan', 'Kegiatan', 'Lainnya']
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                selectedCategory = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                try {
                  final amount = double.tryParse(amountController.text) ?? 0;
                  await _transactionService!.createTransaction(
                    amount: amount,
                    type: 'EXPENSE',
                    category: selectedCategory!,
                    description: descriptionController.text,
                    userId: widget.user.id,
                  );

                  _showSuccessSnackbar(context, 'Pengeluaran berhasil dicatat');
                  Navigator.pop(context);
                  await _refreshData(); // Refresh data setelah berhasil
                } catch (e) {
                  _showErrorSnackbar(context, 'Gagal mencatat pengeluaran: $e');
                }
              } else {
                _showErrorSnackbar(context, 'Harap isi semua field');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog(BuildContext context) {
    _showInfoDialog(
      context,
      'Transfer Dana',
      'Fitur transfer dana akan segera hadir.',
    );
  }

  void _showReportDialog(BuildContext context) {
    _showInfoDialog(
      context,
      'Laporan Keuangan',
      'Fitur laporan keuangan akan segera hadir.',
    );
  }

  void _showTransactionHistory(BuildContext context) {
    _showInfoDialog(
      context,
      'Riwayat Lengkap',
      'Menampilkan semua riwayat transaksi.',
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Opsi Lainnya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildOptionItem(
                Icons.download,
                'Ekspor Data',
                'Unduh laporan keuangan',
                () => _showInfoDialog(
                  context,
                  'Ekspor Data',
                  'Fitur ekspor data akan segera hadir.',
                ),
              ),
              _buildOptionItem(
                Icons.print,
                'Cetak Laporan',
                'Print ringkasan keuangan',
                () => _showInfoDialog(
                  context,
                  'Cetak Laporan',
                  'Fitur cetak laporan akan segera hadir.',
                ),
              ),
              _buildOptionItem(
                Icons.notifications,
                'Notifikasi',
                'Pengaturan notifikasi',
                () => _showInfoDialog(
                  context,
                  'Notifikasi',
                  'Pengaturan notifikasi akan segera hadir.',
                ),
              ),
              _buildOptionItem(
                Icons.help,
                'Bantuan',
                'Pusat bantuan dana',
                () => _showInfoDialog(
                  context,
                  'Bantuan',
                  'Pusat bantuan akan segera hadir.',
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue.shade600, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
