import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

// --- Stamp Model ---

class PassportStamp {
  const PassportStamp({
    required this.flag,
    required this.cityCode,
    required this.cityName,
    required this.countryName,
    required this.date,
    this.isCompleted = true,
  });

  final String flag;
  final String cityCode;
  final String cityName;
  final String countryName;
  final String date;
  final bool isCompleted;
}

// --- Collection Model ---

class PassportCollection {
  const PassportCollection({
    required this.icon,
    required this.title,
    required this.current,
    required this.total,
    required this.color,
  });

  final String icon;
  final String title;
  final int current;
  final int total;
  final Color color;

  double get progress => current / total;
}

// --- Stats Model ---

class PassportStat {
  const PassportStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;
}

// --- Trip History Model ---

class TripHistory {
  const TripHistory({
    required this.flag,
    required this.cityName,
    required this.date,
    required this.days,
    required this.stops,
    required this.score,
  });

  final String flag;
  final String cityName;
  final String date;
  final int days;
  final int stops;
  final int score;
}

// --- Persona Category Model ---

class PersonaCategory {
  const PersonaCategory({
    required this.emoji,
    required this.name,
    required this.level,
    required this.progress,
    required this.color,
  });

  final String emoji;
  final String name;
  final int level;
  final double progress;
  final Color color;
}

// ===================== MOCK DATA =====================

class MockPassportData {
  MockPassportData._();

  // Stamps
  static const stamps = [
    PassportStamp(
      flag: '\u{1F1F9}\u{1F1F7}',
      cityCode: 'IST',
      cityName: 'Istanbul',
      countryName: 'Turkiye',
      date: '3/26',
      isCompleted: true,
    ),
    PassportStamp(
      flag: '\u{1F1EE}\u{1F1F9}',
      cityCode: 'ROM',
      cityName: 'Roma',
      countryName: 'Italya',
      date: '2/26',
      isCompleted: true,
    ),
    PassportStamp(
      flag: '\u{1F1EC}\u{1F1F7}',
      cityCode: 'ATH',
      cityName: 'Atina',
      countryName: 'Yunanistan',
      date: '1/26',
      isCompleted: true,
    ),
    PassportStamp(
      flag: '\u{2753}',
      cityCode: '???',
      cityName: '',
      countryName: '',
      date: '',
      isCompleted: false,
    ),
    PassportStamp(
      flag: '\u{2753}',
      cityCode: '???',
      cityName: '',
      countryName: '',
      date: '',
      isCompleted: false,
    ),
    PassportStamp(
      flag: '\u{2753}',
      cityCode: '???',
      cityName: '',
      countryName: '',
      date: '',
      isCompleted: false,
    ),
  ];

  // Stats
  static const stats = [
    PassportStat(icon: Icons.location_city, value: '3', label: 'Sehir'),
    PassportStat(icon: Icons.flag, value: '3', label: 'Ulke'),
    PassportStat(icon: Icons.public, value: '1', label: 'Kita'),
    PassportStat(icon: Icons.place, value: '24', label: 'Durak'),
    PassportStat(icon: Icons.straighten, value: '1,247', label: 'km'),
  ];

  // Goal
  static const goalTarget = 5;
  static const goalCurrent = 3;
  static const goalLabel = 'Hedef: 5 ulke';
  static double get goalProgress => goalCurrent / goalTarget;

  // Collections
  static final collections = [
    PassportCollection(
      icon: '\u{1F3DB}',
      title: 'Antik Dunya',
      current: 2,
      total: 7,
      color: GeezColors.history,
    ),
    PassportCollection(
      icon: '\u{1F355}',
      title: 'Food Capital',
      current: 1,
      total: 5,
      color: GeezColors.foodie,
    ),
    PassportCollection(
      icon: '\u{1F3D6}',
      title: 'Akdeniz',
      current: 2,
      total: 8,
      color: GeezColors.primary,
    ),
  ];

  // Trip History
  static const tripHistory = [
    TripHistory(
      flag: '\u{1F1F9}\u{1F1F7}',
      cityName: 'Istanbul',
      date: 'Mar 2026',
      days: 3,
      stops: 18,
      score: 127,
    ),
    TripHistory(
      flag: '\u{1F1EE}\u{1F1F9}',
      cityName: 'Roma',
      date: 'Feb 2026',
      days: 4,
      stops: 22,
      score: 156,
    ),
    TripHistory(
      flag: '\u{1F1EC}\u{1F1F7}',
      cityName: 'Atina',
      date: 'Jan 2026',
      days: 3,
      stops: 14,
      score: 98,
    ),
  ];

  // Persona Categories
  static const personaCategories = [
    PersonaCategory(
      emoji: '\u{1F355}',
      name: 'Foodie',
      level: 5,
      progress: 0.67,
      color: GeezColors.foodie,
    ),
    PersonaCategory(
      emoji: '\u{1F3DB}',
      name: 'History Buff',
      level: 3,
      progress: 0.45,
      color: GeezColors.history,
    ),
    PersonaCategory(
      emoji: '\u{1F392}',
      name: 'Adventure',
      level: 7,
      progress: 0.82,
      color: GeezColors.adventure,
    ),
    PersonaCategory(
      emoji: '\u{1F3A8}',
      name: 'Culture',
      level: 4,
      progress: 0.53,
      color: GeezColors.culture,
    ),
    PersonaCategory(
      emoji: '\u{1F33F}',
      name: 'Nature',
      level: 1,
      progress: 0.12,
      color: GeezColors.nature,
    ),
  ];
}
