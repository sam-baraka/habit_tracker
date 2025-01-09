import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:solutech_interview/routes/router.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) return const SizedBox.shrink();

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 32,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: isSmallScreen ? 50 : 70,
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                user.displayName[0].toUpperCase(),
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: isSmallScreen ? 32 : 48,
                                ),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 16 : 24),
                            Text(
                              user.displayName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: isSmallScreen ? 24 : 32,
                              ),
                            ),
                            Text(
                              user.email,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.bodyLarge?.color
                                    ?.withOpacity(0.7),
                                fontSize: isSmallScreen ? 16 : 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    BlocBuilder<HabitBloc, HabitState>(
                      builder: (context, habitState) {
                        final totalXP = habitState.habits.fold<int>(
                          0,
                          (sum, habit) => sum + habit.xp,
                        );
                        final level = (totalXP / 100).floor() + 1;

                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.military_tech),
                                title: const Text('Level'),
                                trailing: Text(
                                  level.toString(),
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.star),
                                title: const Text('Total XP'),
                                trailing: Text(
                                  totalXP.toString(),
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.format_list_bulleted),
                                title: const Text('Active Habits'),
                                trailing: Text(
                                  habitState.habits.length.toString(),
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: const Text('About App'),
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Habit Tracker',
                                applicationVersion: '1.0.0',
                                applicationIcon: const FlutterLogo(size: 50),
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Interview Test Submission',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(height: 8),
                                        Text('Developer: Samuel Baraka'),
                                        SelectableText(
                                            'Email: samuel.baraka1981@gmail.com'),
                                        SelectableText('Phone: +254797302429'),
                                        SizedBox(height: 16),
                                        Text(
                                          'A comprehensive habit tracking application built with Flutter and Firebase, '
                                          'demonstrating clean architecture and state management using BLoC pattern.',
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Key Features:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        SizedBox(height: 8),
                                        Text('🔐 Authentication',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '• Secure email/password authentication'),
                                        Text('• Seamless account management'),
                                        SizedBox(height: 8),
                                        Text('📝 Habit Management',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '• Create, edit, and delete habits'),
                                        Text(
                                            '• Customizable frequency and reminders'),
                                        Text(
                                            '• Progress tracking with calendar view'),
                                        Text(
                                            '• Streak monitoring and statistics'),
                                        SizedBox(height: 8),
                                        Text('🎮 Gamification',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text('• Experience points (XP) system'),
                                        Text('• Level progression'),
                                        Text('• Achievement badges'),
                                        Text('• Daily challenges and rewards'),
                                        SizedBox(height: 8),
                                        Text('🔄 Offline-First',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '• Full functionality without internet'),
                                        Text('• Automatic background syncing'),
                                        Text('• Cross-device synchronization'),
                                        Text('• Local storage using Hive'),
                                        SizedBox(height: 8),
                                        Text('🔔 Notifications',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text('• Customizable habit reminders'),
                                        Text(
                                            '• Daily completion notifications'),
                                        SizedBox(height: 8),
                                        Text('🎨 UI/UX',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            '• Responsive design for mobile and web'),
                                        Text('• Dark and light theme support'),
                                        Text('• Material Design 3 components'),
                                        SizedBox(height: 16),
                                        Text(
                                          'Built with Flutter and Firebase, utilizing:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '• BLoC pattern for state management'),
                                        Text('• Clean Architecture principles'),
                                        Text('• Hive for local storage'),
                                        Text('• Firebase for backend services'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        AutoRouter.of(context).replace(const LoginRoute());
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
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
