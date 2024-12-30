import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import 'event_form_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List<HikingEvent> _events = [];
  final EventService _eventService = EventService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _eventService.loadEvents();
      setState(() {
        _events.clear();
        _events.addAll(events);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load events'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addEvent(HikingEvent event) async {
    setState(() {
      event.id = DateTime.now().millisecondsSinceEpoch.toString();
      _events.add(event);
    });
    await _saveEvents();
  }

  Future<void> _updateEvent(HikingEvent event) async {
    setState(() {
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
      }
    });
    await _saveEvents();
  }

  Future<void> _deleteEvent(String id) async {
    setState(() {
      _events.removeWhere((event) => event.id == id);
    });
    await _saveEvents();
  }

  Future<void> _saveEvents() async {
    try {
      await _eventService.saveEvents(_events);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save events'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getMonthAbbreviation(DateTime date) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventFormScreen(
                    onSave: _addEvent,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _events.isEmpty
          ? const Center(
        child: Text('No events yet. Create one by tapping the + button.'),
      )
          : ListView.builder(
        itemCount: _events.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final event = _events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventFormScreen(
                      event: event,
                      onSave: _updateEvent,
                      onDelete: _deleteEvent,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event.date.day.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(_getMonthAbbreviation(event.date)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(event.location),
                              const SizedBox(height: 4),
                              Text(
                                event.difficulty,
                                style: TextStyle(
                                  color: event.difficulty == 'Easy'
                                      ? Colors.green
                                      : event.difficulty == 'Moderate'
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text('${event.duration.inMinutes} minutes'),
                        const SizedBox(width: 16),
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${event.currentParticipants}/${event.maxParticipants} participants',
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.trending_up, size: 16),
                        const SizedBox(width: 4),
                        Text('${event.distance} km'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}