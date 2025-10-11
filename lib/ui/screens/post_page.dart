import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostPageState();
  }
}

class PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              await Supabase.instance.client.from("posts").insert({
                "title": "100 años de soledad",
                "content": "Gabriel Garcia Marquez",
                "profile_id": "a227c4ef-113d-4014-9968-27bdc8e3acdd",
              });
            } on Exception catch (e) {
              print("**********");
              print(e);
            }
          },
          child: Text("Enviar post"),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              var response = await Supabase.instance.client
                  .from("posts")
                  .select("*, profiles(name, email)")
                  .order("created_at", ascending: false)
                  .limit(5);

              for (var post in response) {
                print(post["content"]);
                print(post["profiles"]["name"]);
                print("*****");
              }
            } on Exception catch (e) {
              print("**********");
              print(e);
            }
          },
          child: Text("Get all post"),
        ),
      ],
    );
  }
}
