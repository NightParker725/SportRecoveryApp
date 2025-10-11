import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles252/features/auth/ui/bloc/signup_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupScreenState();
  }
}

class SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("*******");
    print(Supabase.instance.client.auth.currentUser);
    print("+++++++");
    print(Supabase.instance.client.auth.currentSession);
  }

  Widget content() => Column(
    children: [
      TextField(
        controller: emailController,
        decoration: InputDecoration(label: Text("Correo electronico")),
      ),
      TextField(
        controller: nameController,
        decoration: InputDecoration(label: Text("Nombre")),
      ),
      TextField(
        controller: passwordController,
        decoration: InputDecoration(label: Text("Constraseña")),
        obscureText: true,
      ),
      submmitButton(),
    ],
  );

  Widget submmitButton() => BlocBuilder<SignupBloc, SignupState>(
    builder: (context, state) => ElevatedButton(
      onPressed: () {
        context.read<SignupBloc>().add(
          SubmmitSignupEvent(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        );
      },
      child: Text("Crear usuario"),
    ),
  );

  Widget dynamicContent() => BlocBuilder<SignupBloc, SignupState>(
    builder: (context, state) {
      if (state is SignupIdleState) {
        return content();
      } else if (state is SignupLoadingState) {
        return CircularProgressIndicator();
      } else if (state is SignupSuccessState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/profile');
        });
        return SizedBox.shrink();
      } else {
        return SizedBox.shrink();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: dynamicContent()));
  }
}
