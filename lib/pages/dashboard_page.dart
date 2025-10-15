import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';
import '../widgets/expense_chart.dart';
import '../theme/app_theme.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';
import 'transactions_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();
    // Provider'ı başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        // Loading durumu
        if (transactionProvider.isLoading) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Bütçe Takip'),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Veriler yükleniyor...',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Bütçe Takip'),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  // Ay seçici modal açılacak
                  _showMonthPicker();
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Verileri yenile
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Özet Kartları
                  _buildSummaryCards(transactionProvider),
                  const SizedBox(height: 24),
                  
                  // Pasta Grafik Bölümü
                  _buildChartSection(),
                  const SizedBox(height: 24),
                  
                  // Son İşlemler
                  _buildRecentTransactions(transactionProvider),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionPage(),
                ),
              );
              // Sayfa döndüğünde otomatik güncellenecek (Consumer sayesinde)
            },
            icon: const Icon(Icons.add),
            label: const Text('İşlem Ekle'),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(TransactionProvider provider) {
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;
    final netBalance = provider.netBalance;
    
    return Column(
      children: [
        // İlk satır
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Toplam Gelir',
                amount: '₺${totalIncome.toStringAsFixed(0)}',
                subtitle: 'Bu ay',
                icon: Icons.trending_up,
                color: AppTheme.secondaryColor,
                isPositive: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Toplam Gider',
                amount: '₺${totalExpense.toStringAsFixed(0)}',
                subtitle: 'Bu ay',
                icon: Icons.trending_down,
                color: AppTheme.errorColor,
                isPositive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // İkinci satır
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Net Bakiye',
                amount: '₺${netBalance.toStringAsFixed(0)}',
                subtitle: netBalance >= 0 ? 'Pozitif' : 'Negatif',
                icon: Icons.account_balance_wallet,
                color: netBalance >= 0 ? AppTheme.primaryColor : AppTheme.errorColor,
                isPositive: netBalance >= 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'Toplam İşlem',
                amount: '${provider.transactions.length}',
                subtitle: 'Kayıt',
                icon: Icons.receipt_long,
                color: AppTheme.warningColor,
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Harcama Dağılımı',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionsPage(),
                          ),
                        );
                      },
                      child: const Text('Detayları Gör'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Gerçek pasta grafik
                ExpenseChart(
                  expensesByCategory: provider.expensesByCategory,
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildRecentTransactions(TransactionProvider provider) {
    final recentTransactions = provider.recentTransactions;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Son İşlemler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionsPage(),
                  ),
                );
              },
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (recentTransactions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz işlem bulunmuyor',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İlk işleminizi eklemek için + butonuna tıklayın',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...recentTransactions.map((transaction) => TransactionItem(
            transaction: transaction,
            onEdit: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionPage(transaction: transaction),
                ),
              );
            },
            onDelete: () {
              provider.deleteTransaction(transaction.id);
            },
          )),
      ],
    );
  }

  void _showMonthPicker() {
    final currentDate = DateTime.now();
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ay Seçin'),
        content: SizedBox(
          width: 200,
          height: 300,
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              final monthIndex = index + 1;
              final isCurrentMonth = monthIndex == currentDate.month;
              
              return ListTile(
                leading: Text(
                  '${monthIndex.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                    color: isCurrentMonth ? AppTheme.primaryColor : null,
                  ),
                ),
                title: Text(
                  months[index],
                  style: TextStyle(
                    fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                    color: isCurrentMonth ? AppTheme.primaryColor : null,
                  ),
                ),
                subtitle: Text('${currentDate.year}'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${months[index]} ${currentDate.year} seçildi'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }
}
