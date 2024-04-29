import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettings extends StatelessWidget {
  const MySettings({Key? key});

  Future<void> deleteUser() async {
    // Get the currently logged-in user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Delete the user
        await user.delete();
        print('User deletion successful');
      } catch (e) {
        print('Error deleting user: $e');
      }
    } else {
      print('No currently logged-in user');
    }
  }

  Future<void> deleteUserData(String userId) async {
    try {
      // Get a reference to the Firestore database
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Delete user data
      await users.doc(userId).delete();
      print('User data deletion successful');
    } catch (e) {
      print('Error deleting user data: $e');
    }
  }

  Future<void> setLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6D71D2), Color(0xFF202475)],
          ),
        ),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Notification'),
                    content: Text('Do you want to sign out?'),
                    actions: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFA8ABFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  onPressed: () {
                                    setLogout();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/splash', (route) => false);
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('No',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                  minVerticalPadding: 0,
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('Notification'),
                    content:
                        Text('Are you sure you want to delete your account?'),
                    actions: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFA8ABFF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  onPressed: () async {
                                    try {
                                      User? currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      if (currentUser != null) {
                                        await deleteUser();
                                        await deleteUserData(currentUser.uid);
                                        print(
                                            'User withdrawal process completed');
                                      } else {
                                        print('No currently logged-in user');
                                      }
                                    } catch (e) {
                                      print(
                                          'Error processing user withdrawal: $e');
                                    }
                                    setLogout();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/splash', (route) => false);
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('No',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                  minVerticalPadding: 0,
                  title: Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Icons by Icons8',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
