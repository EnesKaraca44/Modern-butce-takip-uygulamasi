import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';

class ExpenseChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const ExpenseChart({
    super.key,
    required this.expensesByCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (expensesByCategory.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 64,
                color: AppTheme.textSecondaryColor,
              ),
              SizedBox(height: 8),
              Text(
                'Henüz harcama yok',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalExpense = expensesByCategory.values.fold(0.0, (sum, amount) => sum + amount);
    final chartData = <PieChartSectionData>[];
    final colors = [
      const Color(0xFFF97316), // Orange - Yemek
      const Color(0xFF3B82F6), // Blue - Fatura
      const Color(0xFF8B5CF6), // Violet - Ulaşım
      const Color(0xFFEC4899), // Pink - Alışveriş
      const Color(0xFFF59E0B), // Amber - Konut
      const Color(0xFF06B6D4), // Cyan - Eğlence
      const Color(0xFFEF4444), // Red - Sağlık
      const Color(0xFF10B981), // Emerald - Diğer
    ];

    int colorIndex = 0;
    expensesByCategory.forEach((category, amount) {
      final percentage = (amount / totalExpense * 100).round();
      if (percentage > 0) {
        chartData.add(
          PieChartSectionData(
            color: colors[colorIndex % colors.length],
            value: amount,
            title: '${percentage}%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
        colorIndex++;
      }
    });

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: chartData,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Kategori legend'ı
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: expensesByCategory.entries.map((entry) {
            final colorIndex = expensesByCategory.keys.toList().indexOf(entry.key);
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[colorIndex % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${entry.key} (₺${entry.value.toStringAsFixed(0)})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
