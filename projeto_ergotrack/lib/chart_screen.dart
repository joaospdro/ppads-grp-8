import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/bottom_navigation.dart';

class UsageStatsChartScreen extends StatelessWidget {
  final Map<String, dynamic> stats;
  const UsageStatsChartScreen({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final int completed = stats['completed'] ?? 0;
    final int missed = stats['missed'] ?? 0;
    final bool hasData = completed > 0 || missed > 0;
    final Color green = const Color(0xFF388E3C);
    final Color background = const Color(0xFFB4CEAA);
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // Espaço extra para não sobrepor o botão de voltar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hábitos Concluídos vs Perdidos',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: green),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: hasData
                            ? BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: (completed > missed ? completed : missed).toDouble() + 1,
                                  minY: 0,
                                  barTouchData: BarTouchData(enabled: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text('Concluídos', style: TextStyle(color: green, fontWeight: FontWeight.bold)),
                                              );
                                            case 1:
                                              return Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text('Perdidos', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                              );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                        reservedSize: 48,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(show: true, horizontalInterval: 1),
                                  borderData: FlBorderData(show: false),
                                  barGroups: [
                                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: completed.toDouble(), color: green, width: 32, borderRadius: BorderRadius.circular(6))]),
                                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: missed.toDouble(), color: Colors.red, width: 32, borderRadius: BorderRadius.circular(6))]),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Sem dados para exibir',
                                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Chip(
                            label: Text('Concluídos: $completed', style: const TextStyle(color: Colors.white)),
                            backgroundColor: green,
                          ),
                          Chip(
                            label: Text('Perdidos: $missed', style: const TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BottomNavigation(selectedIndex: 0),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Voltar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
