import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Activity>> getActivitiesByDate(DateTime date) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('activities')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList();
  }

  Future<List<Activity>> getActivitiesByDateRange(DateTime startDate, DateTime endDate) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final start = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('activities')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThanOrEqualTo: end)
        .get();

    return snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList();
  }

  Future<Map<String, Map<String, int>>> getActivityStatsByDate(DateTime date) async {
    final activities = await getActivitiesByDate(date);
    return _calculateStats(activities);
  }

  Future<Map<String, Map<String, int>>> getActivityStatsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final activities = await getActivitiesByDateRange(startDate, endDate);
    return _calculateStats(activities);
  }

  Map<String, Map<String, int>> _calculateStats(List<Activity> activities) {
    Map<String, Map<String, int>> stats = {
      'Postura': {'completed': 0, 'missed': 0},
      'Alongamento': {'completed': 0, 'missed': 0},
      'Água': {'completed': 0, 'missed': 0},
      'Pausa': {'completed': 0, 'missed': 0},
    };

    for (var activity in activities) {
      if (!stats.containsKey(activity.type)) {
        stats[activity.type] = {'completed': 0, 'missed': 0};
      }
      
      if (activity.completed) {
        stats[activity.type]!['completed'] = (stats[activity.type]!['completed'] ?? 0) + 1;
      } else {
        stats[activity.type]!['missed'] = (stats[activity.type]!['missed'] ?? 0) + 1;
      }
    }

    return stats;
  }
}