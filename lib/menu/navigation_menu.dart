import 'package:flutter/material.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/login_user.dart';
import 'package:lorsoth111/menu/about_us.dart';
import 'package:lorsoth111/menu/change_password.dart';
import 'package:lorsoth111/menu/contact_us.dart';
import 'package:lorsoth111/menu/faqs.dart';
import 'package:lorsoth111/menu/feedback_nav.dart';
import 'package:lorsoth111/menu/invite_friends.dart';
import 'package:lorsoth111/menu/my_profile.dart';
import 'package:lorsoth111/menu/promotion.dart';
import 'package:lorsoth111/menu/terms_of_use.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  String? fullname;
  String? email;

  Future<void> loadData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      fullname = sp.getString("FULLNAME");
      email = sp.getString("EMAIL");
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("$fullname"),
            accountEmail: Text("$email"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/images/kv1.jpg", fit: BoxFit.cover),
              ),
            ),
            decoration: BoxDecoration(color: AppColors.bgColor),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("About Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_in_talk),
            title: Text("Contact Us"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Promotions"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Promotion()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text("FAQs"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Faqs()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text("Feedback"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackNav()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text("Terms of Use"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfUse()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Invite Friends"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InviteFriends()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("My Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.password),
            title: Text("Change Password"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePassword()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginUser()),
              );
            },
          ),
        ],
      ),
    );
  }
}
