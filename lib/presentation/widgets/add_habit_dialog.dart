import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';

class AddHabitDialog extends StatefulWidget {
  final String userId;
  final Habit? habit;

  const AddHabitDialog({
    super.key,
    required this.userId,
    this.habit,
  });

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  int _frequency = 1;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name);
    _descriptionController = TextEditingController(text: widget.habit?.description);
    _frequency = widget.habit?.frequency ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final habit = widget.habit?.copyWith(
            name: _nameController.text,
            description: _descriptionController.text,
            frequency: _frequency,
          ) ??
          Habit.create(
            name: _nameController.text,
            description: _descriptionController.text,
            userId: widget.userId,
            frequency: _frequency,
          );

      context.read<HabitBloc>().add(
            widget.habit != null
                ? UpdateHabit(habit)
                : AddHabit(habit),
          );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.habit != null ? 'Edit Habit' : 'Add New Habit'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Morning Meditation',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., 10 minutes of mindfulness',
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Frequency: '),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _frequency,
                    items: List.generate(7, (index) => index + 1)
                        .map((freq) => DropdownMenuItem(
                              value: freq,
                              child: Text('$freq times per week'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _frequency = value);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.habit != null ? 'Save' : 'Add'),
        ),
      ],
    );
  }
} 