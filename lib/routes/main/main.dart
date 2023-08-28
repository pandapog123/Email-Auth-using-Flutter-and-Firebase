import 'package:code/state/auth/auth_bloc.dart';
import 'package:code/state/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainRoute extends StatefulWidget {
  static const name = "MainRoute";

  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  final authenticationRepository = AuthenticationRepository(
    auth: FirebaseAuth.instance,
  );

  Future<void> handleSignOut() async {
    final authBloc = context.read<AuthBloc>();

    await authBloc.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
    final userState = authBloc.state;

    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Your signed in as...",
                      style: theme.textTheme.titleLarge,
                    ),
                    Container(
                      color: theme.colorScheme.primary,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        userState?.email ?? "No Email",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  ],
                ),
                FilledButton(
                  onPressed: handleSignOut,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: theme.textTheme.titleLarge,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign out"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
