import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference db = FirebaseDatabase.instance.reference();

  void createPost({String user,title,content}){
    try{
      String create = DateTime.now().toIso8601String();
      db.child('$user').set({
        'title':'$title',
        'content':'$content',
        'create':'$create',
      });
    }catch(e){
      print(e);
    }
  }

  void getPost({String user,title,content}){
    try{
      db.once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value}');
      });
    }catch(e){
      print(e);
    }
  }

  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
        String lastName,
        String email,
        String password}) async {
    var u = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = '$firstName $lastName';
    return await u.updateProfile(info);
  }


  Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }
}