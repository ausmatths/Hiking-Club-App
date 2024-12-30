class HikingEvent {
  String? id;
  String title;
  String description;
  DateTime date;
  String location;
  int maxParticipants;
  int currentParticipants;
  String difficulty;
  double distance;
  Duration duration;

  HikingEvent({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.maxParticipants,
    this.currentParticipants = 0,
    required this.difficulty,
    required this.distance,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'difficulty': difficulty,
      'distance': distance,
      'duration': duration.inMinutes,
    };
  }

  factory HikingEvent.fromMap(Map<String, dynamic> map) {
    return HikingEvent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      maxParticipants: map['maxParticipants'],
      currentParticipants: map['currentParticipants'],
      difficulty: map['difficulty'],
      distance: map['distance'],
      duration: Duration(minutes: map['duration']),
    );
  }
}