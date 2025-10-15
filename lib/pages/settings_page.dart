import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/transaction_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Veri Yönetimi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Veri Yönetimi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.delete_sweep, color: AppTheme.errorColor),
                    title: const Text('Tüm Verileri Temizle'),
                    subtitle: const Text('Tüm işlemler kalıcı olarak silinir'),
                    onTap: () => _showClearDataDialog(context),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Uygulama Bilgileri
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Uygulama Bilgileri',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                    title: const Text('Versiyon'),
                    subtitle: const Text('1.0.0'),
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.storage, color: AppTheme.secondaryColor),
                    title: const Text('Veri Saklama'),
                    subtitle: const Text('SharedPreferences'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verileri Temizle'),
        content: const Text(
          'Tüm işlemler kalıcı olarak silinecek. Bu işlem geri alınamaz. '
          'Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<TransactionProvider>(context, listen: false).clearAllData();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tüm veriler temizlendi'),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                );
              }
            },
            child: const Text(
              'Temizle',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
