import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica_sabado/services/auth.dart';
import 'package:practica_sabado/utils/widgets.dart';
import 'package:practica_sabado/view/home.dart';
import 'package:practica_sabado/view/login/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider<AuthService>(
    child: MyApp(),
    builder: (BuildContext context) {
      return AuthService();
    },
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }

            // redirect to the proper page
            return snapshot.hasData ? HomePage(snapshot.data) : LoginPage();
          } else {
            // show loading indicator
            return LoadingCircle();
          }
        },
      ),
    );
  }
}
