import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/core/db/repositories/UserRepository.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/features/groups/GroupsScreen.dart';

import '../../components/molecules/AppTitle.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen ({super.key});

  @override
  ConsumerState<Homescreen> createState() => _State();
}

class _State extends ConsumerState<Homescreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  Future<void> signIn(BuildContext context) async {
    setState(() => _isLoading = true);

    var username = _usernameController.text.trim();
    final userProvider = ref.read(currentUserProvider.notifier);
    final userRepository = ref.read(userRepositoryProvider);


    if (username.isEmpty){
      setState(() => _isLoading = false);
      return; //no tu bedzie popup
    }
    
    var existingUser = await userRepository.getUser(username);
    
    if (existingUser == null){
      var id = await userRepository.addUser(username);
      userProvider.setUser(AppUser(id: id, username: username));
    }
    else{
      userProvider.setUser(existingUser);
    }

    if (!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GroupsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: Apptitle(showBack:false),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              enabled: _isLoading,
            ),
            ElevatedButton(onPressed:  () async => await signIn(context), child: _isLoading ? CircularProgressIndicator() : Text("Zaloguj"))
          ],
        ),
      ));
  }




}
