import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:solutech_interview/presentation/widgets/habit_card.dart';
import 'package:solutech_interview/presentation/widgets/add_habit_dialog.dart';

@RoutePage()
class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  void initState() {
    super.initState();
    // Load habits when the page is created
    final user = context.read<AuthBloc>().state.user;
    if (user != null) {
      context.read<HabitBloc>().add(LoadHabits(user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocListener<HabitBloc, HabitState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
        if (state.lastCompletedHabit != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Great job! Habit marked as completed.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Habits'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddHabitDialog(userId: user!.id),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            if (state.status == HabitStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.habits.isEmpty) {
              return const Center(
                child: Text('No habits yet. Add one to get started!'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.habits.length,
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                return HabitCard(habit: habit);
              },
            );
          },
        ),
      ),
    );
  }
} 