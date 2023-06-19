import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/views/register_view.dart';

import '../models/user_model.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.getUserDetails(),
      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Center(
            child: GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 22,
                width: MediaQuery.of(context).size.width / 2.8,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          );
        } else {
          UserModel user = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white, // Arka plan rengi
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.8,
                    child: Image.asset(
                      "assets/undraw_personal_information_re_vw8a.png",
                      fit: BoxFit
                          .contain, // Görüntüyü tam ortalamak için fit: BoxFit.contain ekledik
                    ),
                  ),
                  SizedBox(
                      height:
                          16), // Image ile arasına boşluk eklemek için SizedBox kullandık
                  ListTile(
                    title: Text(
                      'Username',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${user.username}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Name',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'E-mail',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${user.email}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Phone Number',
                      style: TextStyle(color: Colors.orange, fontSize: 21),
                    ),
                    subtitle: Text(
                      '${user.phone}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('token');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 22,
                        width: MediaQuery.of(context).size.width / 2.8,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
