import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../core/utils/enums_utils.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String phoneNumber;
  final OpeningHours openingHours;
  final List<String> cuisines;
  final double rating;
  final String? imageUrl;
  final RestaurantType type;
  final RestaurantStatus status;
  final VegNonVeg vegNonVeg;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.openingHours,
    required this.cuisines,
    required this.rating,
    this.imageUrl,
    required this.type,
    required this.status,
    required this.vegNonVeg,
  });

  // FIXED: Robust JSON serialization that handles both String and List
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      type: RestaurantType.values.byName(json['type']),
      status: RestaurantStatus.values.byName(json['status']),
      vegNonVeg: VegNonVeg.values.byName(json['vegNonVeg']),
      // FIXED: Handle both String and List for cuisines
      cuisines: _parseCuisines(json['cuisines']),
      openingHours: OpeningHours.fromJson(json['openingHours']),
    );
  }

  // Helper method to handle cuisines parsing
  static List<String> _parseCuisines(dynamic cuisinesData) {
    if (cuisinesData == null) {
      return [];
    } else if (cuisinesData is String) {
      // If it's a string, split by comma and trim whitespace
      return cuisinesData
          .split(',')
          .map((cuisine) => cuisine.trim())
          .where((cuisine) => cuisine.isNotEmpty)
          .toList();
    } else if (cuisinesData is List) {
      // If it's already a list, convert to List<String>
      return List<String>.from(cuisinesData);
    } else {
      // Fallback for unexpected data types
      return [cuisinesData.toString()];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'imageUrl': imageUrl,
      'type': type.name,
      'status': status.name,
      'vegNonVeg': vegNonVeg.name,
      'cuisines': cuisines, // Will be saved as List
      'openingHours': openingHours.toJson(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    phoneNumber,
    openingHours,
    cuisines,
    rating,
    imageUrl,
    type,
    status,
    vegNonVeg,
  ];
}

// Opening Hours Model (unchanged)
class OpeningHours {
  final Map<String, DaySchedule> schedule;

  OpeningHours({required this.schedule});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    Map<String, DaySchedule> schedule = {};
    json.forEach((day, scheduleJson) {
      schedule[day] = DaySchedule.fromJson(scheduleJson);
    });
    return OpeningHours(schedule: schedule);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    schedule.forEach((day, daySchedule) {
      json[day] = daySchedule.toJson();
    });
    return json;
  }

  bool isOpenNow() {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final daySchedule = schedule[dayName];

    if (daySchedule == null || !daySchedule.isOpen) return false;

    final currentTime = TimeOfDay.fromDateTime(now);
    return _isTimeBetween(
      currentTime,
      daySchedule.openTime,
      daySchedule.closeTime,
    );
  }

  String _getDayName(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[weekday - 1];
  }

  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Handles overnight hours (e.g., 10 PM to 2 AM)
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
}

// Day Schedule Model (unchanged)
class DaySchedule {
  final bool isOpen;
  final TimeOfDay openTime;
  final TimeOfDay closeTime;

  DaySchedule({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      isOpen: json['isOpen'],
      openTime: TimeOfDay(
        hour: json['openTime']['hour'],
        minute: json['openTime']['minute'],
      ),
      closeTime: TimeOfDay(
        hour: json['closeTime']['hour'],
        minute: json['closeTime']['minute'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOpen': isOpen,
      'openTime': {'hour': openTime.hour, 'minute': openTime.minute},
      'closeTime': {'hour': closeTime.hour, 'minute': closeTime.minute},
    };
  }
}
