import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/bottom_navigation.dart';
import 'services/activity_service.dart';
import 'services/export_service.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();
  
  final ActivityService _activityService = ActivityService();
  final ExportService _exportService = ExportService();
  
  Map<String, Map<String, int>> _stats = {
    'Postura': {'completed': 0, 'missed': 0},
    'Alongamento': {'completed': 0, 'missed': 0},
    'Água': {'completed': 0, 'missed': 0},
    'Pausa': {'completed': 0, 'missed': 0},
  };
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final stats = await _activityService.getActivityStatsByDate(selectedDate);
      if (!mounted) return;
      
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar dados: ${e.toString()}")),
      );
    }
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _loadStats();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (!mounted) return;
    
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _selectMainDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (!mounted) return;
    
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _loadStats();
    }
  }
  
  Future<void> _exportData(bool isPdf) async {
  setState(() {
    _isLoading = true;
  });
  
  try {
    final stats = await _activityService.getActivityStatsByDateRange(fromDate, toDate);
    
    final file = isPdf 
      ? await _exportService.exportToPdf(stats, fromDate, toDate)
      : await _exportService.exportToCsv(stats);
    
    if (!mounted) return;
    
    await _exportService.shareFile(file);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Relatório gerado com sucesso!")),
    );
  } catch (e) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao exportar dados: ${e.toString()}")),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4CEAA),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(),
                  _buildDateSelector(),
                  _buildTable(),
                  _buildExportSection(),
                  const Spacer(),
                  const BottomNavigation(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.blue[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, color: Colors.white),
          const SizedBox(width: 10),
          const Text(
            "Histórico de atividades",
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const Icon(Icons.arrow_left), onPressed: () => _changeDate(-1)),
        GestureDetector(
          onTap: () => _selectMainDate(context),
          child: Text(
            DateFormat('dd/MM/yy').format(selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(icon: const Icon(Icons.arrow_right), onPressed: () => _changeDate(1)),
      ],
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow("Seguimento", "✔", "✖", isHeader: true),
          ..._stats.entries.map((entry) => _buildTableRow(
            entry.key, 
            entry.value['completed'].toString(), 
            entry.value['missed'].toString()
          )),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String title, String value1, String value2, {bool isHeader = false}) {
    return TableRow(
      children: [
        _buildTableCell(title, isHeader),
        _buildTableCell(value1, isHeader),
        _buildTableCell(value2, isHeader),
      ],
    );
  }

  Widget _buildTableCell(String text, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 16),
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue[700],
            child: const Center(
              child: Text("Exportar dados", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDatePicker("De", fromDate, true),
              _buildDatePicker("Até", toDate, false),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("PDF"),
                onPressed: () => _exportData(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.table_chart),
                label: const Text("CSV"),
                onPressed: () => _exportData(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isFromDate) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => _selectDate(context, isFromDate),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 5),
                Text(DateFormat('dd/MM/yy').format(date)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}