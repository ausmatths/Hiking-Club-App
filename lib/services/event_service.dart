import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class EventService {
  static const String _key = 'hiking_events';

  Future<void> saveEvents(List<HikingEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventMaps = events.map((event) => event.toMap()).toList();
    await prefs.setString(_key, jsonEncode(eventMaps));
  }

  Future<List<HikingEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString(_key);
    if (eventsJson == null) {
      return [];
    }

    final eventMaps = List<Map<String, dynamic>>.from(
      jsonDecode(eventsJson).map((x) => Map<String, dynamic>.from(x)),
    );
    return eventMaps.map((map) => HikingEvent.fromMap(map)).toList();
  }
}