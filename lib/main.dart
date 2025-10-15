import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'pages/dashboard_page.dart';
import 'providers/transaction_provider.dart';

void main() {
  runApp(const ButceApp());
}

class ButceApp extends StatelessWidget {
  const ButceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        title: 'Bütçe Takip',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const DashboardPage(),
      ),
    );
  }
}

