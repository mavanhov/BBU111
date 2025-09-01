import 'package:flutter/material.dart';
import 'package:lorsoth111/app_colors.dart';
import 'package:lorsoth111/cards/category_screen.dart';
import 'package:lorsoth111/cards/contact_screen.dart';
import 'package:lorsoth111/cards/group_screen.dart';
import 'package:lorsoth111/cards/help_screen.dart';
import 'package:lorsoth111/cards/product_screen.dart';
import 'package:lorsoth111/cards/setting_screen.dart';
import 'package:lorsoth111/menu/favorite_items.dart';
import 'package:lorsoth111/menu/navigation_menu.dart';
import 'package:lorsoth111/menu/new_order.dart';
import 'package:lorsoth111/menu/popular_items.dart';

class AppDashboard extends StatefulWidget {
  const AppDashboard({super.key});

  @override
  State<AppDashboard> createState() => _AppDashboardState();
}

class _AppDashboardState extends State<AppDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BBU STORE'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text('New Order'),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Popular Items'),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.favorite, color: AppColors.red),
                  title: Text('Favorite Items'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  // go to New Order Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewOrder()),
                  );
                  break;
                case 2:
                  // go to Popular Items Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopularItems(),
                    ),
                  );
                  break;
                case 3:
                  // go to Favorite Items Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteItems(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
      drawer: const NavigationMenu(),
      body: Container(
        color: AppColors.bgHome,
        child: Stack(
          children: <Widget>[
            // background
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            // contents
            ListView(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: <Widget>[
                Container(
                  height: 140,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            'Good Afternoon!',
                            style: TextStyle(
                              color: AppColors.bgColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 36, 10, 10),
                          child: Text('BTB 111'),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.bgColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      6.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'My Orders'.toUpperCase(),
                                  style: TextStyle(color: AppColors.textColor),
                                ),
                              ),
                              SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Top News'.toUpperCase(),
                                  style: TextStyle(color: AppColors.bgColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.bgColor,
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(3),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/kv1.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    // card 1
                    cardBox('Contacts', Icons.person),
                    // card 2
                    cardBox('Groups', Icons.people),
                    // card 3
                    cardBox('Products', Icons.shopping_cart),
                    // card 4
                    cardBox('Categories', Icons.playlist_add_check),
                    // card 5
                    cardBox('Helps', Icons.question_mark),
                    // card 6
                    cardBox('Settings', Icons.settings),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBox(String title, IconData icon) {
    return SizedBox(
      child: Card(
        // InkWell, InkResponse, GestureDetector
        child: InkWell(
          onTap: () {
            if (title == 'Contacts') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              );
            } else if (title == 'Groups') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupScreen()),
              );
            } else if (title == 'Products') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductScreen()),
              );
            } else if (title == 'Categories') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryScreen()),
              );
            } else if (title == 'Helps') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            } else if (title == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingScreen()),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(180),
                ),
                child: Icon(icon, size: 55, color: AppColors.textColor),
              ),
              SizedBox(height: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.bgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
