import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/routes/router.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Welcome Back!'),
            ],
          ),
          content: Text(
            'You are successfully logged in as ${context.read<AuthBloc>().state.user?.email}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.of(context).pop();
              },
              child: const Text('Not me'),
            ),
            TextButton(
              onPressed: () {
                context.router.replace(const MainHomeRoute());
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 800;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
          // Show success dialog and navigate when authenticated
          if (state.user != null) {
            _showSuccessDialog();
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? screenSize.width * 0.1 : 16.0,
                vertical: 16.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Icon
                      Center(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(isDesktop ? 30 : 20),
                          child: Image.asset(
                            'assets/icon/icon.jpeg',
                            width: isDesktop ? 200 : 120,
                            height: isDesktop ? 200 : 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 40 : 24),

                      Text(
                        'Welcome Back',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: isDesktop ? 32 : 24,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isDesktop ? 32 : 24),

                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.email_outlined),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isDesktop ? 20 : 16,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: isDesktop ? 24 : 16),

                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isDesktop ? 20 : 16,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: isDesktop ? 32 : 24),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width:
                                            isDesktop ? 300 : double.infinity,
                                        height: isDesktop ? 56 : 48,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                    AuthLoginRequested(
                                                      _emailController.text,
                                                      _passwordController.text,
                                                    ),
                                                  );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              vertical: isDesktop ? 16 : 12,
                                            ),
                                          ),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: isDesktop ? 18 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: isDesktop ? 24 : 16),
                                    TextButton(
                                      onPressed: () {
                                        context.router
                                            .replace(const SignUpRoute());
                                      },
                                      child: Text(
                                        'Don\'t have an account? Sign up',
                                        style: TextStyle(
                                          fontSize: isDesktop ? 16 : 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
