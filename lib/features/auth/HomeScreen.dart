import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/core/db/repositories/UserRepository.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'package:niezapominapka/features/auth/app_user.dart';

import '../../components/molecules/AppTitle.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen ({super.key});

  @override
  ConsumerState<Homescreen> createState() => _State();
}

class _State extends ConsumerState<Homescreen> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> signIn(BuildContext context, CurrentUser userProvider, UserRepository userRepository) async {
    var username = _usernameController.text;

    if (username.isEmpty){
      return; //no tu bedzie popup
    }
    
    var existingUser = await userRepository.getUser(username);
    
    if (existingUser == null){
      userRepository.addUser(username);
    }
    
    userProvider.setUser(AppUser(username: username));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.read(currentUserProvider.notifier);
    final userRepository = ref.read(userRepositoryProvider);
    
    return Scaffold(appBar: Apptitle(),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
            ),
            ElevatedButton(onPressed: () => signIn(context, userProvider, userRepository), child: Text("Zaloguj"))
          ],
        ),
      ));
  }




}
