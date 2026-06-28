class RiskPlace {
  const RiskPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.reminderText,
    this.enabled = true,
    this.lastTriggeredAt,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final String reminderText;
  final bool enabled;
  final DateTime? lastTriggeredAt;

  RiskPlace copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    String? reminderText,
    bool? enabled,
    DateTime? lastTriggeredAt,
    bool clearLastTriggeredAt = false,
  }) {
    return RiskPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      reminderText: reminderText ?? this.reminderText,
      enabled: enabled ?? this.enabled,
      lastTriggeredAt:
          clearLastTriggeredAt ? null : lastTriggeredAt ?? this.lastTriggeredAt,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'radiusMeters': radiusMeters,
        'reminderText': reminderText,
        'enabled': enabled,
        'lastTriggeredAt': lastTriggeredAt?.toIso8601String(),
      };

  factory RiskPlace.fromJson(Map<String, Object?> json) {
    return RiskPlace(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toInt(),
      reminderText: json['reminderText'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      lastTriggeredAt: json['lastTriggeredAt'] == null
          ? null
          : DateTime.tryParse(json['lastTriggeredAt'] as String),
    );
  }
}

class PickedPlace {
  const PickedPlace({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String address;
  final double latitude;
  final double longitude;
}
