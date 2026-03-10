import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationProvider extends ChangeNotifier {
  int _points = 0;
  int _streak = 0;
  List<String> _badges = [];
  final Map<String, int> _skillProgress = {};

  int get points => _points;
  int get streak => _streak;
  List<String> get badges => _badges;
  Map<String, int> get skillProgress => _skillProgress;

  GamificationProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('points') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _badges = prefs.getStringList('badges') ?? [];
    notifyListeners();
  }

  Future<void> addPoints(int amount, {String? skill}) async {
    _points += amount;
    if (skill != null) {
      _skillProgress[skill] = (_skillProgress[skill] ?? 0) + amount;
    }
    _checkBadges();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
    notifyListeners();
  }

  void incrementStreak() {
    _streak++;
    notifyListeners();
  }

  void _checkBadges() {
    if (_points >= 100 && !_badges.contains('Beginner')) {
      _badges.add('Beginner 🌱');
    }
    if (_points >= 500 && !_badges.contains('Intermediate')) {
      _badges.add('Intermediate ⚡');
    }
    if (_points >= 1000 && !_badges.contains('Expert')) {
      _badges.add('Expert 🔥');
    }
  }

  int get level => (_points / 100).floor() + 1;
  double get levelProgress => (_points % 100) / 100.0;
}
