import 'package:flutter/material.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/app_dashboard.dart';
import 'package:lorsoth111/signup_user.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login User')),
      body: ListView(
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
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AppDashboard()),
                  (route) => false,
                );
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
                    MaterialPageRoute(builder: (context) => const SignupUser()),
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
    );
  }
}
