abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthSignupRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  AuthSignupRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
