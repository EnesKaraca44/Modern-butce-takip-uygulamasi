import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  List<Transaction> get recentTransactions => 
      _transactions.take(5).toList();

  // İlk yükleme
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _transactions = await StorageService.loadTransactions();
      
      // İlk kez açılıyorsa örnek veriler ekle
      if (_transactions.isEmpty && await StorageService.isFirstLaunch()) {
        await _addSampleData();
        await StorageService.setFirstLaunchCompleted();
      }
    } catch (e) {
      print('Error loading transactions: $e');
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Örnek veriler ekle
  Future<void> _addSampleData() async {
    final sampleTransactions = [
      Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Hoş Geldiniz!',
        amount: 0.0,
        category: 'Maaş',
        date: DateTime.now(),
        description: 'İlk işleminizi eklemek için + butonuna tıklayın',
        type: TransactionType.income,
      ),
    ];
    
    _transactions = sampleTransactions;
    await StorageService.saveTransactions(_transactions);
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get netBalance => totalIncome - totalExpense;

  // İşlem ekleme
  Future<void> addTransaction(Transaction transaction) async {
    _transactions.insert(0, transaction); // En üste ekle
    await StorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  // İşlem güncelleme
  Future<void> updateTransaction(Transaction updatedTransaction) async {
    final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      await StorageService.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  // İşlem silme
  Future<void> deleteTransaction(String transactionId) async {
    _transactions.removeWhere((t) => t.id == transactionId);
    await StorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  // Tüm verileri temizle
  Future<void> clearAllData() async {
    await StorageService.clearAllData();
    _transactions = [];
    notifyListeners();
  }

  // Kategoriye göre harcamalar
  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryExpenses = {};
    
    for (final transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        categoryExpenses[transaction.category] = 
            (categoryExpenses[transaction.category] ?? 0) + transaction.amount;
      }
    }
    
    return categoryExpenses;
  }

  // Bu ayki işlemler
  List<Transaction> get currentMonthTransactions {
    final now = DateTime.now();
    return _transactions.where((t) => 
        t.date.year == now.year && t.date.month == now.month).toList();
  }
}
