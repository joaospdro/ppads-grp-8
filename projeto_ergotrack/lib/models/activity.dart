import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String type;
  final DateTime timestamp;
  final String userId;
  final bool completed;
  final String? notes;

  Activity({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.userId,
    required this.completed,
    this.notes,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      type: data['type'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      completed: data['completed'] ?? false,
      notes: data['notes'],
    );
  }
}