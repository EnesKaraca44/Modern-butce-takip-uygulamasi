import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';
import '../theme/app_theme.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> _filteredTransactions = [];
  String _selectedFilter = 'Tümü';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterOptions = [
    'Tümü',
    'Bu Ay',
    'Bu Hafta',
    'Gelir',
    'Gider',
    'Yemek',
    'Ulaşım',
    'Fatura',
    'Eğlence',
    'Maaş',
  ];

  @override
  void initState() {
    super.initState();
    // Provider henüz hazır olmayabilir, bu yüzden burada çağırmıyoruz
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        // Provider'dan gelen veriler değiştiğinde filtreleri yeniden uygula
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_filteredTransactions.isEmpty && provider.transactions.isNotEmpty) {
            _applyFilters(provider);
          }
        });
        
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Text('Tüm İşlemler'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterBottomSheet,
              ),
            ],
          ),
          body: Column(
            children: [
              // Arama Çubuğu
              _buildSearchBar(),
              
              // Filtre Çipleri
              _buildFilterChips(),
              
              // İşlem Listesi
              Expanded(
                child: _buildTransactionsList(provider),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionPage(),
                ),
              );
              // Sayfa döndüğünde listeyi yenile
              _applyFilters(provider);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'İşlem ara...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _applyFilters(Provider.of<TransactionProvider>(context, listen: false));
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.outlineColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.outlineColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: AppTheme.surfaceColor,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
          _applyFilters(Provider.of<TransactionProvider>(context, listen: false));
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = selected ? filter : 'Tümü';
                });
                _applyFilters(Provider.of<TransactionProvider>(context, listen: false));
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionsList(TransactionProvider provider) {
    if (_filteredTransactions.isEmpty) {
      return _buildEmptyState();
    }

    // Tarihlere göre grupla
    final groupedTransactions = _groupTransactionsByDate(_filteredTransactions);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        _applyFilters(provider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedTransactions.length,
        itemBuilder: (context, index) {
          final date = groupedTransactions.keys.elementAt(index);
          final transactions = groupedTransactions[date]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarih başlığı
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateHeader(date),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${transactions.length} işlem',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // O günkü işlemler
              ...transactions.map((transaction) => TransactionItem(
                transaction: transaction,
                onEdit: () => _editTransaction(transaction),
                onDelete: () => _deleteTransaction(transaction, provider),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'İşlem bulunamadı',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Arama kriterlerinizi değiştirin veya yeni işlem ekleyin',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('İşlem Ekle'),
          ),
        ],
      ),
    );
  }

  void _applyFilters(TransactionProvider provider) {
    List<Transaction> filtered = List.from(provider.transactions);

    // Filtre uygula
    switch (_selectedFilter) {
      case 'Bu Ay':
        final now = DateTime.now();
        filtered = filtered.where((t) => 
          t.date.year == now.year && t.date.month == now.month).toList();
        break;
      case 'Bu Hafta':
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        filtered = filtered.where((t) => 
          t.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          t.date.isBefore(weekEnd.add(const Duration(days: 1)))).toList();
        break;
      case 'Gelir':
        filtered = filtered.where((t) => t.type == TransactionType.income).toList();
        break;
      case 'Gider':
        filtered = filtered.where((t) => t.type == TransactionType.expense).toList();
        break;
      default:
        if (_selectedFilter != 'Tümü') {
          filtered = filtered.where((t) => t.category == _selectedFilter).toList();
        }
        break;
    }

    // Arama uygula
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) => 
        t.title.toLowerCase().contains(_searchQuery) ||
        t.category.toLowerCase().contains(_searchQuery) ||
        (t.description?.toLowerCase().contains(_searchQuery) ?? false)).toList();
    }

    setState(() {
      _filteredTransactions = filtered;
      _sortTransactionsByDate();
    });
  }

  void _sortTransactionsByDate() {
    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};
    
    for (final transaction in transactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    
    return grouped;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Bugün';
    } else if (targetDate == yesterday) {
      return 'Dün';
    } else {
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }

  void _editTransaction(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(transaction: transaction),
      ),
    );
  }

  void _deleteTransaction(Transaction transaction, TransactionProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İşlemi Sil'),
        content: Text('${transaction.title} işlemini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTransaction(transaction.id);
              _applyFilters(provider);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('İşlem silindi'),
                  backgroundColor: AppTheme.secondaryColor,
                ),
              );
            },
            child: const Text(
              'Sil',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filtreler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? filter : 'Tümü';
                    });
                    _applyFilters(Provider.of<TransactionProvider>(context, listen: false));
                    Navigator.pop(context);
                  },
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  checkmarkColor: AppTheme.primaryColor,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 'Tümü';
                    _searchController.clear();
                    _searchQuery = '';
                  });
                  _applyFilters(Provider.of<TransactionProvider>(context, listen: false));
                  Navigator.pop(context);
                },
                child: const Text('Filtreleri Temizle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
