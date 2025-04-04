import 'package:flutter/material.dart';

class AlarmSettingsScreen extends StatefulWidget {
  @override
  _AlarmSettingsScreenState createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  List<bool> selectedDays = [false, true, false, true, false, true, false];
  TimeOfDay startTime = TimeOfDay(hour: 7, minute: 30);
  TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
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
            const SizedBox(height: 20),
            const Text(
              "Ajuste de alarme pausa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSection("Dias da semana"),
            _buildWeekDays(),
            _buildSection("Período"),
            _buildTimePicker(),
            _buildSection("Frequência"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "20 Minutos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            BottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.blue.shade700,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWeekDays() {
    List<String> days = ["D", "S", "T", "Q", "Q", "S", "S"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return Column(
          children: [
            Text(days[index], style: TextStyle(fontSize: 16)),
            Checkbox(
              value: selectedDays[index],
              onChanged: (bool? value) {
                setState(() {
                  selectedDays[index] = value!;
                });
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeBox("Início", startTime, true),
        Icon(Icons.access_time, size: 30),
        _buildTimeBox("Término", endTime, false),
      ],
    );
  }

  Widget _buildTimeBox(String label, TimeOfDay time, bool isStart) {
    return GestureDetector(
      onTap: () => _selectTime(context, isStart),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: Icon(Icons.home, size: 30), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications, size: 30, color: Colors.red), onPressed: () {}),
          IconButton(icon: Icon(Icons.rocket_launch, size: 30), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings, size: 30), onPressed: () {}),
        ],
      ),
    );
  }
}