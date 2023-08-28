import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code/state/auth/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, User?> {
  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<User?> userSubscription;

  AuthBloc({
    required this.authenticationRepository,
  }) : super(null) {
    on<AuthSignOut>(handleSignOut);

    on<AuthUserChanged>(handleUserChange);

    userSubscription = authenticationRepository.user.listen((user) {
      add(AuthUserChanged(user: user));
    });
  }

  void handleUserChange(AuthUserChanged event, Emitter<User?> emit) async {
    emit(event.user);
  }

  void handleSignOut(AuthSignOut event, Emitter<User?> emit) async {
    await authenticationRepository.signOutAsync();
  }

  Future<void> loginWithEmail(String email, String password) async {
    await authenticationRepository.logInWithEmail(email, password);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    await authenticationRepository.signUpWithEmail(email, password);
  }

  Future<void> signOut() async {
    await authenticationRepository.signOutAsync();
  }

  @override
  Future<void> close() async {
    await userSubscription.cancel();

    return super.close();
  }
}
