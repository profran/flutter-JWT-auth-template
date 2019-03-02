import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './models.dart';
import './events.dart';

const BASE_URL = '';
const LOGIN_ENDPOINT = BASE_URL + '';

class AuthBloc {
  bool _isLoggedIn = false;
  String _token;

  final _loginStateController = StreamController<AuthState>();
  Sink<AuthState> get _inAuthState => _loginStateController.sink;
  Stream<AuthState> get authState => _loginStateController.stream;

  final _loginEventController = StreamController<AuthEvent>();
  Sink<AuthEvent> get authEventSink => _loginEventController.sink;

  AuthBloc() {
    _loginEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(AuthEvent event) async {
    if (event is LoginEvent) {
      await login(event.authCredentials).then((token) {
        this._token = token;
        this._isLoggedIn = true;
      }).catchError((error) {
        this._token = null;
        this._isLoggedIn = false;
        print(error.toString());
      });

      this._inAuthState.add(AuthState(
            token: this._token,
            isLoggedIn: this._isLoggedIn,
          ));
    } else {
      this._token = null;
      this._isLoggedIn = false;

      this._inAuthState.add(AuthState(
            token: this._token,
            isLoggedIn: this._isLoggedIn,
          ));
    }
  }

  Future<String> login(AuthCredentials creds) async {
    var response = await http.post(LOGIN_ENDPOINT,
        body: {'username': creds.username, 'password': creds.password});

    if (response.statusCode == 200) {
      return json.decode(response.body)['token'];
    } else {
      throw Exception(json.decode(response.body)['error']);
    }
  }

  void dispose() {
    _loginStateController.close();
    _loginEventController.close();
  }
}
