import 'package:uuid/uuid.dart';

class Birthday {
  final String id;
  final String name;
  final DateTime date;
  final String? phoneNumber;
  final bool remindOnDay;
  final bool remindOneDayBefore;
  final bool remindOneWeekBefore;
  final String? avatarUrl;

  Birthday({
    String? id,
    required this.name,
    required this.date,
    this.phoneNumber,
    this.remindOnDay = true,
    this.remindOneDayBefore = false,
    this.remindOneWeekBefore = false,
    this.avatarUrl,
  }) : id = id ?? const Uuid().v4();

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'phoneNumber': phoneNumber,
      'remindOnDay': remindOnDay,
      'remindOneDayBefore': remindOneDayBefore,
      'remindOneWeekBefore': remindOneWeekBefore,
      'avatarUrl': avatarUrl,
    };
  }

  factory Birthday.fromJson(Map json) {
    return Birthday(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      phoneNumber: json['phoneNumber'],
      remindOnDay: json['remindOnDay'] ?? true,
      remindOneDayBefore: json['remindOneDayBefore'] ?? false,
      remindOneWeekBefore: json['remindOneWeekBefore'] ?? false,
      avatarUrl: json['avatarUrl'],
    );
  }

  Birthday copyWith({
    String? name,
    DateTime? date,
    String? phoneNumber,
    bool? remindOnDay,
    bool? remindOneDayBefore,
    bool? remindOneWeekBefore,
    String? avatarUrl,
  }) {
    return Birthday(
      id: id,
      name: name ?? this.name,
      date: date ?? this.date,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      remindOnDay: remindOnDay ?? this.remindOnDay,
      remindOneDayBefore: remindOneDayBefore ?? this.remindOneDayBefore,
      remindOneWeekBefore: remindOneWeekBefore ?? this.remindOneWeekBefore,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
