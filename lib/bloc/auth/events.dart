import './models.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final AuthCredentials authCredentials;

  LoginEvent(this.authCredentials);
}

class LogoutEvent extends AuthEvent {}
