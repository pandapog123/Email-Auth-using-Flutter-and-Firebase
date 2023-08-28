part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthSignOut extends AuthEvent {
  const AuthSignOut();
}

final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged({
    required this.user,
  });

  final User? user;
}
