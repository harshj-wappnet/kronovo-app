import 'package:flutter/material.dart';
import 'package:kronovo_app/pages/home_page.dart';
import 'package:kronovo_app/pages/members_page/members_details_page.dart';
import 'drawer_header.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              HeaderDrawer(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'lato'),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text(
                  "Members",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'lato'),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MembersDetailsPage(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}