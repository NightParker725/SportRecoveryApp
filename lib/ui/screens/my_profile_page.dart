import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyProfilePageState();
  }
}

class MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _signout();
          },
          child: Text("Cerrar sesion"),
        ),
      ],
    );
  }

  Future<void> _signout() async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
