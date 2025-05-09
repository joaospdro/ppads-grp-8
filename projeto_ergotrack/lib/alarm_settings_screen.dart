import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_ergotrack/services/notification_service.dart';
import 'widgets/bottom_navigation.dart';
import 'activity_history_screen.dart';
import 'package:flutter/foundation.dart';

class AlarmSettingsScreen extends StatefulWidget {
  final String notificationType;
  
  const AlarmSettingsScreen({
    required this.notificationType, 
    super.key
  });
  
  @override
  State<AlarmSettingsScreen> createState() => _AlarmSettingsScreenState();
}

class _AlarmSettingsScreenState extends State<AlarmSettingsScreen> {
  List<bool> selectedDays = [false, true, false, true, false, true, false];
  TimeOfDay startTime = const TimeOfDay(hour: 7, minute: 30);
  TimeOfDay endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isSaving = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

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

  void _triggerTestNotification() async {
    try {
      await _notificationService.showInstantNotification(
        999, // ID único para notificação de teste
        'Teste de Notificação',
        'Esta é uma notificação de teste do modo debug',
      );
    } catch (e) {
      if (mounted) {
        _showMessage('Erro ao disparar notificação: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4CEAA),
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
            _buildSection("Tipo de Notificação"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.notificationType,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildSection("Frequência"),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "20 Minutos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            if (kDebugMode) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.red,
                ),
                onPressed: _triggerTestNotification,
                child: const Text('TESTAR NOTIFICAÇÃO (DEBUG)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade700,
                ),
                onPressed: _isSaving ? null : _saveSettings,
                child: _isSaving 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar Configurações'),
              ),
            ),
            const BottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.blue.shade700,
      child: Text(
        title,
        style: const TextStyle(
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
            Text(days[index], style: const TextStyle(fontSize: 16)),
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
        const Icon(Icons.access_time, size: 30),
        _buildTimeBox("Término", endTime, false),
      ],
    );
  }

  Widget _buildTimeBox(String label, TimeOfDay time, bool isStart) {
    return GestureDetector(
      onTap: () => _selectTime(context, isStart),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage('Usuário não autenticado!', isError: true);
        return;
      }

      await _notificationService.cancelAllNotifications();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
            'alarmSettings': {
              'selectedDays': selectedDays,
              'startTime': '${startTime.hour}:${startTime.minute}',
              'endTime': '${endTime.hour}:${endTime.minute}',
              'notificationType': widget.notificationType
            }
          }, SetOptions(merge: true));

      final now = DateTime.now();
      
      try {
        int scheduledDaysCount = 0;
        for (int i = 0; i < selectedDays.length; i++) {
          if (selectedDays[i]) {
            final nextDate = _getNextWeekday(now, i);
            await _notificationService.scheduleNotification(
              id: i + 1,
              title: widget.notificationType,
              body: 'Lembre-se de fazer uma pausa e se alongar',
              scheduledDate: nextDate,
            );
            scheduledDaysCount++;
          }
        }
        
        if (scheduledDaysCount == 0) {
          if (mounted) {
            _showMessage('Configurações salvas, mas nenhum dia foi selecionado para notificações.', isWarning: true);
          }
        }
      } catch (notifError) {
        // Substituir print por log
        debugPrint('Erro ao agendar notificações: $notifError');
        if (mounted) {
          _showMessage('Configurações salvas, mas as notificações podem ter horários aproximados devido a restrições do sistema.', isWarning: true);
        }
      }

      if (mounted) {
        _showMessage('Configurações salvas!');
      }
      
      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ActivityHistoryScreen()),
      );
    } catch (e) {
      // Substituir print por log
      debugPrint('Erro completo ao salvar: $e');
      
      if (!mounted) return;
      
      String errorMessage = 'Erro ao salvar as configurações';
      if (e.toString().contains('exact_alarms_not_permitted')) {
        errorMessage = 'Permissão para alarmes exatos não concedida. Verifique as configurações do aplicativo.';
      }
      
      _showMessage(errorMessage, isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false, bool isWarning = false}) {
    if (!mounted) return;
    
    Color backgroundColor = isError 
        ? Colors.red 
        : (isWarning ? Colors.orange : Colors.green);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: isError || isWarning ? 4 : 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
      ),
    );
  }

  DateTime _getNextWeekday(DateTime from, int weekday) {
    final daysUntil = (weekday - from.weekday + 7) % 7;
    
    if (daysUntil == 0) {
      final currentTimeMinutes = from.hour * 60 + from.minute;
      final startTimeMinutes = startTime.hour * 60 + startTime.minute;
      final endTimeMinutes = endTime.hour * 60 + endTime.minute;
      
      if (currentTimeMinutes >= startTimeMinutes && currentTimeMinutes <= endTimeMinutes) {
        return DateTime(
          from.year,
          from.month,
          from.day,
          from.hour,
          from.minute + 1,
        );
      }
    }
    
    return DateTime(
      from.year,
      from.month,
      from.day + daysUntil,
      startTime.hour,
      startTime.minute,
    );
  }
}