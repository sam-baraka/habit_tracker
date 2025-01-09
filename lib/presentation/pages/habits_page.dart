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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 1200,
          ),
          child: BlocBuilder<HabitBloc, HabitState>(
            builder: (context, state) {
              if (state.status == HabitStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.habits.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon/icon.jpeg',
                          width: isSmallScreen ? 100 : 150,
                          height: isSmallScreen ? 100 : 150,
                        ),
                        SizedBox(height: isSmallScreen ? 24 : 32),
                        Text(
                          'No habits yet',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: isSmallScreen ? 24 : 32,
                              ),
                        ),
                        // ... rest of the empty state UI
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 32,
                  vertical: 16,
                ),
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  return HabitCard(habit: habit);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
