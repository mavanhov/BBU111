import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lorsoth111/app_colors.dart';

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  State<SignupUser> createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  bool isPassword = true;
  bool isConfirmPassword = true;

  final txtPassword = FocusNode();
  final txtConfirmPassword = FocusNode();

  void togglePassword() {
    setState(() {
      isPassword = !isPassword;
      if (txtPassword.hasPrimaryFocus) return;
      txtPassword.canRequestFocus = false;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      isConfirmPassword = !isConfirmPassword;
      if (txtConfirmPassword.hasPrimaryFocus) return;
      txtConfirmPassword.canRequestFocus = false;
    });
  }

  final _keyForm = GlobalKey<FormState>();
  TextEditingController controllerFullname = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirm = TextEditingController();

  Future<void> signupUser(
    String fullname,
    String email,
    String password,
  ) async {
    try {
      EasyLoading.show(status: 'Inserting...');
      await Future.delayed(Duration(seconds: 1));
      // Create user with Email and Password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      // Save user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullname': fullname,
        'email': email,
        'createdAt': DateTime.now(),
      });
      EasyLoading.showSuccess('Added user successfully.');
      if (!mounted) return;
      Navigator.pop(context);
    } catch (ex) {
      EasyLoading.showError('Error: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up User')),
      body: Form(
        key: _keyForm,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Image.asset(
                'assets/images/tch.png',
                width: 120,
                height: 120,
              ),
            ),

            Container(
              margin: EdgeInsets.all(5),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'FullName is Required!';
                  }
                  return null;
                },
                controller: controllerFullname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(5),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(5),
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
                obscureText: isPassword,
                focusNode: txtPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: togglePassword,
                    child: Icon(
                      isPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(5),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is Required!';
                  }
                  if (value != controllerPassword.text.trim()) {
                    return 'Passwords Do Not Match!';
                  }
                  return null;
                },
                controller: controllerConfirm,
                obscureText: isConfirmPassword,
                focusNode: txtConfirmPassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: GestureDetector(
                    onTap: toggleConfirmPassword,
                    child: Icon(
                      isConfirmPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 55,
              margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    String fullname = controllerFullname.text;
                    String email = controllerEmail.text;
                    String password = controllerPassword.text.trim();
                    signupUser(fullname, email, password);
                  }
                },
                child: Text('OK', style: TextStyle(color: AppColors.textColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
