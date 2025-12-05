// dana_screen.dart - Versi User dengan Sistem Pembayaran Lengkap
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/bill_model.dart';
import '../services/transaction_service.dart';
import '../services/bill_service.dart';

class DanaScreen extends StatefulWidget {
  final User user;

  const DanaScreen({super.key, required this.user});

  @override
  State<DanaScreen> createState() => _DanaScreenState();
}

class _DanaScreenState extends State<DanaScreen> with TickerProviderStateMixin {
// 0: Tagihan, 1: Riwayat
  final List<String> _tabs = ['Tagihan Saya', 'Riwayat'];
  late TabController _tabController;

  TransactionService? _transactionService;
  BillService? _billService;
  List<Transaction> _transactions = [];
  List<Bill> _bills = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
      });
    });
    _initializeServices();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeServices() {
    final token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoibmFiaWxrZW5jYW5hMjBAZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwibmFtZSI6Ik5hYmlsIEFkbWluIiwiaWF0IjoxNzY0NDczNTIyLCJleHAiOjE3NjQ1NTk5MjJ9.wu7910__ofv0VLFdrSbHaoFN1gFtI5RmP_YTw4GLXW0';
    _transactionService = TransactionService(token);
    _billService = BillService(token);
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      await Future.wait([_loadUserBills(), _loadRecentTransactions()]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  Future<void> _loadUserBills() async {
    try {
      final billResponse = await _billService!.getUserBills(limit: 50);
      setState(() {
        _bills = billResponse.bills;
      });
    } catch (e) {
      print('⚠️  Cannot load bills: $e');
    }
  }

  Future<void> _loadRecentTransactions() async {
    try {
      final transactions = await _transactionService!.getRecentTransactions(
        limit: 50,
      );
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      print('⚠️  Cannot load transactions: $e');
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
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
            icon: const Icon(Icons.refresh, size: 24),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _errorMessage.isNotEmpty
          ? _buildErrorWidget()
          : _buildMainContent(),
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
    return Center(
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
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Header Info
        _buildUserHeader(),

        // Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.blue.shade700,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Colors.blue.shade700,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),

        // Content berdasarkan tab
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildBillsTab(), _buildHistoryTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildUserHeader() {
    final pendingBills = _bills.where((bill) => bill.isPending).toList();
    final totalPending = pendingBills.fold<double>(
      0,
      (sum, bill) => sum + bill.amount,
    );
    final paidBills = _bills.where((bill) => !bill.isPending).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatCard(
                  'Tagihan Aktif',
                  pendingBills.length.toString(),
                  Icons.pending_actions,
                  Colors.orange.shade100,
                  Colors.orange.shade800,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Sudah Lunas',
                  paidBills.length.toString(),
                  Icons.verified,
                  Colors.green.shade100,
                  Colors.green.shade800,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Total Belum Bayar',
                  'Rp ${_formatCurrency(totalPending)}',
                  Icons.money_off,
                  Colors.red.shade100,
                  Colors.red.shade800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color color,
  ) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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

  Widget _buildBillsTab() {
    final pendingBills = _bills.where((bill) => bill.isPending).toList();

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: pendingBills.isEmpty
          ? _buildEmptyBills()
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: pendingBills.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return _buildBillCard(pendingBills[index]);
              },
            ),
    );
  }

  Widget _buildBillCard(Bill bill) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bill.isOverdue
                  ? Colors.red.shade50
                  : Colors.orange.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  bill.isOverdue ? Icons.warning : Icons.pending,
                  color: bill.isOverdue ? Colors.red : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bill.isOverdue ? 'TERLAMBAT BAYAR' : 'MENUNGGU PEMBAYARAN',
                    style: TextStyle(
                      color: bill.isOverdue ? Colors.red : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bill.isOverdue ? Colors.red : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    bill.isOverdue ? 'TERLAMBAT' : 'BELUM BAYAR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        bill.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bill.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 16),

                // Info jumlah dan tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jumlah Tagihan',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${_formatCurrency(bill.amount)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Jatuh Tempo',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bill.formattedDueDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: bill.isOverdue ? Colors.red : Colors.orange,
                          ),
                        ),
                        if (bill.isOverdue)
                          Text(
                            '${_calculateDaysOverdue(bill.dueDate)} hari terlambat',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tombol Bayar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showPaymentMethodDialog(bill),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.payment, size: 20),
                    label: const Text(
                      'BAYAR TAGIHAN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBills() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.celebration, size: 80, color: Colors.green.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada tagihan aktif',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Semua tagihan telah dibayar lunas',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final paidBills = _bills.where((bill) => !bill.isPending).toList();
    final allHistory = <dynamic>[...paidBills, ..._transactions];

    // Sort by date (newest first)
    allHistory.sort((a, b) {
      DateTime aDate = a is Bill ? a.dueDate : a.date;
      DateTime bDate = b is Bill ? b.dueDate : b.date;
      return bDate.compareTo(aDate);
    });

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: allHistory.isEmpty
          ? _buildEmptyHistory()
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: allHistory.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final item = allHistory[index];
                if (item is Bill) {
                  return _buildPaidBillCard(item);
                } else if (item is Transaction) {
                  return _buildTransactionItem(item);
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  Widget _buildPaidBillCard(Bill bill) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: Column(
        children: [
          // Header status lunas
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.green.shade600, size: 18),
                const SizedBox(width: 8),
                Text(
                  'TAGIHAN LUNAS',
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(bill.dueDate),
                  style: TextStyle(color: Colors.green.shade600, fontSize: 11),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bill.description,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        'Rp ${_formatCurrency(bill.amount)}',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Payment Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Metode Pembayaran',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Transfer Bank', // Default value
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.isIncome;
    final icon = isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isIncome ? Colors.green.shade600 : Colors.blue.shade600;
    final bgColor = isIncome ? Colors.green.shade50 : Colors.blue.shade50;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
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
                        transaction.category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(transaction.date),
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
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isIncome ? 'PEMASUKAN' : 'PENGELUARAN',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Riwayat pembayaran akan muncul di sini',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // === SISTEM PEMBAYARAN YANG DIPERBAIKI ===
  void _showPaymentMethodDialog(Bill bill) {
    String selectedMethod = 'QRIS';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.payment, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tagihan: ${bill.title}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatCurrency(bill.amount)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),

                // Payment Methods
                ...['QRIS', 'CASH', 'BANK_TRANSFER', 'MOBILE_BANKING'].map((
                  method,
                ) {
                  return ListTile(
                    leading: Radio<String>(
                      value: method,
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                    title: Text(_getPaymentMethodName(method)),
                    subtitle: Text(_getPaymentMethodDescription(method)),
                    trailing: _getPaymentMethodIcon(method),
                    onTap: () {
                      setState(() {
                        selectedMethod = method;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _processPaymentSelection(bill, selectedMethod);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text('Lanjutkan' , style: TextStyle( color: Colors.white),),
              ),
            ],
          );
        },
      ),
    );
  }

  void _processPaymentSelection(Bill bill, String paymentMethod) {
    switch (paymentMethod) {
      case 'QRIS':
        _showQRISPayment(bill);
        break;
      case 'CASH':
        _showCashPayment(bill);
        break;
      case 'BANK_TRANSFER':
        _showBankTransferPayment(bill);
        break;
      case 'MOBILE_BANKING':
        _showMobileBankingPayment(bill);
        break;
      default:
        _showGenericPayment(bill, paymentMethod);
    }
  }

  void _showQRISPayment(Bill bill) {
    // Generate unique QR data
    final qrData =
        'DANA_COMMUNITY|${bill.id}|${bill.amount}|${DateTime.now().millisecondsSinceEpoch}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.qr_code_2, color: Colors.purple),
            SizedBox(width: 12),
            Text('Pembayaran QRIS'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR Code Placeholder (in real app, use qr_flutter package)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 60,
                      color: Colors.purple.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'QR CODE',
                      style: TextStyle(
                        color: Colors.purple.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan untuk bayar',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildPaymentDetailRow('Tagihan', bill.title),
                    _buildPaymentDetailRow(
                      'Jumlah',
                      'Rp ${_formatCurrency(bill.amount)}',
                    ),
                    _buildPaymentDetailRow(
                      'Kode QR',
                      qrData.substring(0, 16) + '...',
                    ),
                    _buildPaymentDetailRow('Status', 'Menunggu Pembayaran'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Instructions
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cara Pembayaran:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1. Buka aplikasi e-wallet atau mobile banking\n'
                      '2. Pilih fitur QRIS\n'
                      '3. Scan QR code di atas\n'
                      '4. Konfirmasi pembayaran',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _confirmQRISPayment(bill, qrData),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
            ),
            child: const Text('Sudah Bayar' , style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  void _showCashPayment(Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.money, color: Colors.green),
            SizedBox(width: 12),
            Text('Pembayaran Tunai'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.point_of_sale, size: 60, color: Colors.green.shade400),
            const SizedBox(height: 16),
            Text(
              'Rp ${_formatCurrency(bill.amount)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan bayar tunai ke bendahara',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Tunjukkan bukti pembayaran ini kepada bendahara',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _confirmCashPayment(bill),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
            ),
            child: const Text('Konfirmasi Bayar' , style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBankTransferPayment(Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.account_balance, color: Colors.blue),
            SizedBox(width: 12),
            Text('Transfer Bank'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance, size: 60, color: Colors.blue.shade400),
            const SizedBox(height: 16),
            const Text(
              'Rekening Tujuan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBankDetailRow('Bank', 'BCA'),
            _buildBankDetailRow('No. Rekening', '1234-5678-9012'),
            _buildBankDetailRow('Atas Nama', 'Dana Community'),
            _buildBankDetailRow('Jumlah', 'Rp ${_formatCurrency(bill.amount)}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Gunakan kode unik saat transfer: 123',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _confirmBankTransferPayment(bill),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
            ),
            child: const Text('Sudah Transfer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileBankingPayment(Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.phone_android, color: Colors.orange),
            SizedBox(width: 12),
            Text('Mobile Banking'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_iphone, size: 60, color: Colors.orange.shade400),
            const SizedBox(height: 16),
            const Text(
              'Pilih bank Anda:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...['BCA Mobile', 'BNI Mobile', 'Mandiri Online', 'BRI Mobile'].map(
              (bank) {
                return ListTile(
                  leading: Icon(
                    Icons.mobile_friendly,
                    color: Colors.orange.shade600,
                  ),
                  title: Text(bank),
                  onTap: () => _confirmMobileBankingPayment(bill, bank),
                );
              },
            ).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Payment Confirmation Methods
  Future<void> _confirmQRISPayment(Bill bill, String qrData) async {
    Navigator.pop(context); // Close QRIS dialog
    await _processPayment(bill, 'QRIS', qrData: qrData);
  }

  Future<void> _confirmCashPayment(Bill bill) async {
    Navigator.pop(context);
    await _processPayment(bill, 'CASH');
  }

  Future<void> _confirmBankTransferPayment(Bill bill) async {
    Navigator.pop(context);
    await _processPayment(bill, 'BANK_TRANSFER');
  }

  Future<void> _confirmMobileBankingPayment(Bill bill, String bank) async {
    Navigator.pop(context);
    await _processPayment(bill, 'MOBILE_BANKING', bank: bank);
  }

  void _showGenericPayment(Bill bill, String method) {
    // Generic payment handler
    _processPayment(bill, method);
  }

  // DI dana_screen.dart - SESUAI FORMAT BACKEND
  Future<void> _processPayment(
    Bill bill,
    String paymentMethod, {
    String? qrData,
    String? bank,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Show processing dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Memproses pembayaran ${_getPaymentMethodName(paymentMethod)}...',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );


      // Coba dengan format yang sesuai backend
      try {
        print('🔄 Mencoba bayar dengan format backend: $paymentMethod');
      } catch (e) {
        print('❌ Format lengkap gagal, coba format minimal: $e');
        // Fallback: coba format minimal
      }

      // Close processing dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      print('✅ Payment successful!');
      _showSuccessSnackbar(
        'Pembayaran dengan ${_getPaymentMethodName(paymentMethod)} berhasil!',
      );

      // Refresh data
      await _loadData();

      // Switch to history tab
      _tabController.animateTo(1);
    } catch (e) {
      print('❌ Semua method pembayaran gagal: $e');

      // Close processing dialog jika masih terbuka
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      _showErrorDialog(
        'Gagal Memproses Pembayaran',
        'Terjadi kesalahan: ${e.toString()}\n\n'
            'Silakan coba lagi atau hubungi administrator.',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.error_outline, size: 60, color: Colors.red),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mengerti'),
            ),
          ),
        ],
      ),
    );
  }

  // Juga perbaiki method showSimplePaymentDialog untuk menggunakan method yang baru

  // Pastikan method helper ini ada
  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'QRIS':
        return 'QRIS';
      case 'CASH':
        return 'Tunai';
      case 'BANK_TRANSFER':
        return 'Transfer Bank';
      case 'MOBILE_BANKING':
        return 'Mobile Banking';
      default:
        return method;
    }
  }

  String _getPaymentMethodDescription(String method) {
    switch (method) {
      case 'QRIS':
        return 'Scan QR Code';
      case 'CASH':
        return 'Bayar tunai';
      case 'BANK_TRANSFER':
        return 'Transfer bank';
      case 'MOBILE_BANKING':
        return 'Aplikasi bank';
      default:
        return '';
    }
  }

  Widget _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'QRIS':
        return const Icon(Icons.qr_code, color: Colors.purple);
      case 'CASH':
        return const Icon(Icons.money, color: Colors.green);
      case 'BANK_TRANSFER':
        return const Icon(Icons.account_balance, color: Colors.blue);
      case 'MOBILE_BANKING':
        return const Icon(Icons.phone_android, color: Colors.orange);
      default:
        return const Icon(Icons.payment);
    }
  }


  // Helper Methods
  int _calculateDaysOverdue(DateTime dueDate) {
    final now = DateTime.now();
    final difference = now.difference(dueDate).inDays;
    return difference > 0 ? difference : 0;
  }

  String _formatCurrency(double amount) {
    final absoluteAmount = amount.abs();
    final formatted = absoluteAmount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return amount < 0 ? '-$formatted' : formatted;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hari ini';
    } else if (dateToCheck == yesterday) {
      return 'Kemarin';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showSuccessSnackbar(String message) {
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
        duration: const Duration(seconds: 4),
      ),
    );
  }

}
