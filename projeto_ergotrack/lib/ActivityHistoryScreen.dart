import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/bottom_navigation.dart';

class ActivityHistoryScreen extends StatefulWidget {
  @override
  _ActivityHistoryScreenState createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now().subtract(Duration(days: 7));
  DateTime toDate = DateTime.now();

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB4CEAA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDateSelector(),
            _buildTable(),
            _buildExportSection(),
            Spacer(),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.blue[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, color: Colors.white),
          SizedBox(width: 10),
          Text(
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
        IconButton(icon: Icon(Icons.arrow_left), onPressed: () => _changeDate(-1)),
        GestureDetector(
          onTap: () => _selectMainDate(context),
          child: Text(
            DateFormat('dd/MM/yy').format(selectedDate),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(icon: Icon(Icons.arrow_right), onPressed: () => _changeDate(1)),
      ],
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        children: [
          _buildTableRow("Seguimento", "✔", "✖", isHeader: true),
          _buildTableRow("Postura", "4", "2"),
          _buildTableRow("Alongamento", "3", "5"),
          _buildTableRow("Água", "7", "1"),
          _buildTableRow("Pausa", "2", "1"),
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
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal, fontSize: 16),
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue[700],
            child: Center(
              child: Text("Exportar dados", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDatePicker("Dê", fromDate, true),
              _buildDatePicker("Até", toDate, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, bool isFromDate) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () => _selectDate(context, isFromDate),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 5),
                Text(DateFormat('dd/MM/yy').format(date)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}