import 'dart:async';
import 'package:flutter/material.dart';
import './bloc/auth/bloc.dart';
import './bloc/auth/events.dart';
import './bloc/auth/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'auth_template',
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: HomeBuilder(),
    );
  }
}

class HomeBuilder extends StatelessWidget {
  final AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: StreamBuilder(
              stream: authBloc.authState,
              initialData: AuthState(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasError && snapshot.hasData) {
                  return Text(snapshot.data.token ?? 'No token');
                } else {
                  return Text(snapshot.error.toString());
                }
              },
            ),
          ),
          FlatButton(
            child: Text('Login'),
            onPressed: () {
              authBloc.authEventSink
                  .add(LoginEvent(AuthCredentials('username', 'password')));
            },
          ),
        ],
      ),
    );
  }
}
