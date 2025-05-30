import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_navigation.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (!mounted) return;
      if (data != null && data['reminders'] != null) {
        final List<dynamic> loaded = data['reminders'];
        setState(() {
          reminders = loaded.map((r) => {
            'type': r['type'],
            'days': List<bool>.from(r['days'] ?? [false, false, false, false, false, false, false]),
            'startTime': TimeOfDay(hour: r['startTime']['hour'], minute: r['startTime']['minute']),
            'endTime': TimeOfDay(hour: r['endTime']['hour'], minute: r['endTime']['minute']),
            'enabled': r['enabled'] ?? true,
          }).toList();
        });
      } else {
        setState(() {
          reminders = [];
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        reminders = [];
      });
    }
  }

  void _editReminder(int index) async {
    final reminder = reminders[index];
    TimeOfDay? newStart = await showTimePicker(
      context: context,
      initialTime: reminder['startTime'],
    );
    if (!mounted || newStart == null) return;
    TimeOfDay? newEnd = await showTimePicker(
      context: context,
      initialTime: reminder['endTime'],
    );
    if (!mounted || newEnd == null) return;
    if (!mounted) return;
    setState(() {
      reminders[index]['startTime'] = newStart;
      reminders[index]['endTime'] = newEnd;
    });
  }

  void _saveReminders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário não autenticado!")),
      );
      return;
    }
    try {
      // Serializa os lembretes para salvar no Firestore
      final remindersToSave = reminders.map((r) => {
        'type': r['type'],
        'days': r['days'],
        'startTime': {'hour': r['startTime'].hour, 'minute': r['startTime'].minute},
        'endTime': {'hour': r['endTime'].hour, 'minute': r['endTime'].minute},
        'enabled': r['enabled'],
      }).toList();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'reminders': remindersToSave}, SetOptions(merge: true));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alterações salvas!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4CEAA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blue[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_active, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Gerenciar Lembretes",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(reminder['type'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Switch(
                                value: reminder['enabled'],
                                onChanged: (val) {
                                  setState(() => reminders[index]['enabled'] = val);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              const SizedBox(width: 6),
                              ...List.generate(7, (d) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  ['D','S','T','Q','Q','S','S'][d],
                                  style: TextStyle(
                                    fontWeight: reminder['days'][d] ? FontWeight.bold : FontWeight.normal,
                                    color: reminder['days'][d] ? Colors.blue[700] : Colors.grey,
                                  ),
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 18),
                              const SizedBox(width: 6),
                              Text("${reminder['startTime'].format(context)} - ${reminder['endTime'].format(context)}"),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                label: const Text("Editar", style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  _editReminder(index);
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text("Remover", style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  setState(() => reminders.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Salvar Alterações"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _saveReminders,
              ),
            ),
            const BottomNavigation(selectedIndex: 1),
          ],
        ),
      ),
    );
  }
}
