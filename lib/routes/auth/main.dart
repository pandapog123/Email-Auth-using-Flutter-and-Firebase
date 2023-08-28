import 'package:code/routes/login/main.dart';
import 'package:code/routes/signup/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRoute extends StatefulWidget {
  static const name = "AuthRoute";

  const AuthRoute({super.key});

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  handleLogin() {
    context.goNamed(LoginRoute.name);
  }

  handleSignup() {
    context.goNamed(SignupRoute.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Email Auth Flutter",
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Log into an existing account or create a new one right away!",
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  FilledButton(
                    onPressed: handleLogin,
                    style: FilledButton.styleFrom(
                      textStyle: theme.textTheme.titleLarge,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Log In"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: handleSignup,
                    style: FilledButton.styleFrom(
                      textStyle: theme.textTheme.titleLarge,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sign up"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
