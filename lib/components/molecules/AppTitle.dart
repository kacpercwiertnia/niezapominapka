import 'package:flutter/material.dart';

class Apptitle extends StatelessWidget implements PreferredSizeWidget{
  const Apptitle ({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset("assets/logo_text.png", height: 40,)
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
