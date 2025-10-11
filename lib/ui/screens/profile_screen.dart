import 'package:flutter/material.dart';
import 'package:moviles252/ui/screens/my_profile_page.dart';
import 'package:moviles252/ui/screens/post_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;

  static List<Widget> _pages = [MyProfilePage(), PostPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: currentPage()),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "Post"),
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }

  Widget currentPage() {
    return _pages[_currentIndex];
  }
}
