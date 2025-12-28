import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget implements PreferredSizeWidget{
  final bool showBack;
  const AppTitle ({super.key, required this.showBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      title: Image.asset("assets/logo_tekst.png", height: 40,)
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
