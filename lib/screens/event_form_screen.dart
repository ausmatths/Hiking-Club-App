import 'package:flutter/material.dart';
import '../models/event.dart';

class EventFormScreen extends StatefulWidget {
  final HikingEvent? event;
  final Function(HikingEvent) onSave;
  final Function(String)? onDelete;

  const EventFormScreen({
    Key? key,
    this.event,
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _maxParticipantsController;
  late TextEditingController _distanceController;
  late TextEditingController _durationController;
  DateTime _selectedDate = DateTime.now();
  String _selectedDifficulty = 'Moderate';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _locationController = TextEditingController(text: widget.event?.location ?? '');
    _maxParticipantsController = TextEditingController(
      text: widget.event?.maxParticipants.toString() ?? '',
    );
    _distanceController = TextEditingController(
      text: widget.event?.distance.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.event?.duration.inMinutes.toString() ?? '',
    );
    if (widget.event != null) {
      _selectedDate = widget.event!.date;
      _selectedDifficulty = widget.event!.difficulty;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxParticipantsController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final event = HikingEvent(
        id: widget.event?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        location: _locationController.text,
        maxParticipants: int.parse(_maxParticipantsController.text),
        currentParticipants: widget.event?.currentParticipants ?? 0,
        difficulty: _selectedDifficulty,
        distance: double.parse(_distanceController.text),
        duration: Duration(minutes: int.parse(_durationController.text)),
      );
      widget.onSave(event);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
        actions: [
          if (widget.event != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Event'),
                    content: const Text('Are you sure you want to delete this event?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          widget.onDelete!(widget.event!.id!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(labelText: 'Maximum Participants'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter maximum participants' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: ['Easy', 'Moderate', 'Hard', 'Expert'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance (km)',
                  suffixText: 'km',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter the distance' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  suffixText: 'min',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter the duration' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.event == null ? 'Create Event' : 'Update Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}