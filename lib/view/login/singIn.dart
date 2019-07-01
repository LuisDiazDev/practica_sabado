import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica_sabado/services/auth.dart';
import 'package:provider/provider.dart';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final _formKey = GlobalKey<FormState>();
  String _password1,_password2;
  String _email,_firsName,_lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crear Cuenta"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(height: 20.0),
                    Text(
                      'Login Information',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        onSaved: (value) => _email = value,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email Address")),
                    TextFormField(
                        onSaved: (value) => _firsName = value,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Firs Name")),
                    TextFormField(
                        onSaved: (value) => _lastName = value,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Last Name")),
                    TextFormField(
                        onSaved: (value) => _password1 = value,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password")),
                    TextFormField(
                        onSaved: (value) => _password2 = value,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Repeat Password")),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      child: Text("SingIn"),
                      onPressed: () async {
                        // save the fields..
                        final form = _formKey.currentState;
                        form.save();
                        // Validate will return true if is valid, or false if invalid.
                        if (form.validate()) {
                          try {
                            FirebaseUser result =
                            await Provider.of<AuthService>(context).createUser(firstName: _firsName,lastName: _lastName ,email: _email,password: _password1);
                          } on AuthException catch (error) {
                            return _buildErrorDialog(context, error.message);
                          } on Exception catch (error) {
                            return _buildErrorDialog(context, error.toString());
                          }
                        }
                      },
                    )
                  ]))
          ),
        )
    );
  }

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}
