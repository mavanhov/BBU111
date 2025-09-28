import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/app_dashboard.dart';
import 'package:lorsoth111/signup_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool ispassword = true;
  final txt = FocusNode();
  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  final _keyForm = GlobalKey<FormState>();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      EasyLoading.show(status: 'Logging In...');
      await Future.delayed(Duration(seconds: 1));

      // Sign In with Email & Password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Login Succeed
        // Save User Login info
        final sp = await SharedPreferences.getInstance();
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        sp.setString('UID', user.uid);
        sp.setString('FULLNAME', data['fullname']);
        sp.setString('EMAIL', data['email']);

        EasyLoading.dismiss();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppDashboard()),
          (route) => false,
        );
      } else {
        EasyLoading.showError('Failed to Login.');
      }
    } catch (ex) {
      EasyLoading.showError('Error: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login User')),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Image.asset(
                'assets/images/tch.png',
                width: 120,
                height: 120,
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is Required!';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email is invalid!';
                  }
                  return null;
                },
                controller: controllerEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is Required!';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
                controller: controllerPassword,
                obscureText: ispassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                      onTap: togglePassword,
                      child: Icon(
                        // condition ? expr1 : expr2
                        ispassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 55,
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    String email = controllerEmail.text;
                    String password = controllerPassword.text.trim();
                    loginUser(email, password);
                  }
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: AppColors.textColor),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColors.bgColor),
                ),
              ),
            ),

            // SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Does not have account?'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupUser(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: AppColors.bgColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
