import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("****");
    print(Supabase.instance.client.auth.currentUser);
  }

  Future<void> _login(String email, String pass) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: pass,
      );
      print("****");
      print(Supabase.instance.client.auth.currentUser);
    } on AuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(label: Text("Correo electronico")),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(label: Text("Constraseña")),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () =>
                  _login(emailController.text, passwordController.text),
              child: Text("Iniciar Sesion"),
            ),
          ],
        ),
      ),
    );
  }
}
