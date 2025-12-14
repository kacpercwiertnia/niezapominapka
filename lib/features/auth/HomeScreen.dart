import 'package:flutter/material.dart';

import '../../components/molecules/AppTitle.dart';

class Homescreen extends StatefulWidget {
  const Homescreen ({super.key});

  @override
  State<Homescreen> createState() => _State();
}

class _State extends State<Homescreen> {
  final TextEditingController _usernameController = TextEditingController();

  void signIn(BuildContext context) {
    //dupa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: Apptitle(),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
            ),
            ElevatedButton(onPressed: () => signIn(context), child: Text("Zaloguj"))
          ],
        ),
      ));
  }


}
