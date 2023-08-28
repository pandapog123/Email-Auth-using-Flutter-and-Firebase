import 'package:code/routes/auth/main.dart';
import 'package:code/routes/login/main.dart';
import 'package:code/routes/main/main.dart';
import 'package:code/routes/signup/main.dart';
import 'package:code/state/auth/auth_bloc.dart';
import 'package:code/state/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RootState extends StatelessWidget {
  const RootState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return AuthBloc(
            authenticationRepository: AuthenticationRepository(
              auth: FirebaseAuth.instance,
            ),
          );
        })
      ],
      child: const Root(),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AuthBloc>().state;

    final router = GoRouter(
      initialLocation: "/auth",
      routes: [
        GoRoute(
          name: AuthRoute.name,
          path: "/auth",
          redirect: (context, state) {
            if (userState != null) {
              return "/main";
            }

            return null;
          },
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const AuthRoute(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
          routes: [
            GoRoute(
              path: "login",
              name: LoginRoute.name,
              pageBuilder: (context, state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LoginRoute(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              },
            ),
            GoRoute(
              path: "signup",
              name: SignupRoute.name,
              pageBuilder: (context, state) {
                return CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SignupRoute(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: MainRoute.name,
          path: "/main",
          redirect: (context, state) {
            if (userState == null) {
              return "/auth";
            }

            return null;
          },
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: const MainRoute(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
