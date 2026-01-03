import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/core/db/repositories/UserRepository.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/features/groups/view/GroupsScreen.dart';
import 'package:niezapominapka/shopRadar/geofence_provider.dart';
import 'package:niezapominapka/shopRadar/permission_service.dart';

import '../../components/molecules/AppTitle.dart';
import '../../components/molecules/AppPage.dart';
import '../../core/notifications/error_notification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen ({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  Future<void> signIn(BuildContext context) async {
    setState(() => _isLoading = true);

    var username = _usernameController.text.trim();
    final userProvider = ref.watch(currentUserProvider.notifier);
    final userRepository = ref.watch(userRepositoryProvider);

    if (username.isEmpty){
      setState(() => _isLoading = false);
      showError(context, "Nazwa użytkownika nie może być pusta");
      return;
    }
    
    var existingUser = await userRepository.getUser(username);
    
    if (existingUser == null){
      var id = await userRepository.addUser(username);
      userProvider.setUser(AppUser(id: id, username: username));
    }
    else{
      userProvider.setUser(existingUser);
    }

    bool hasPermission = await PermissionService.requestLocationPermissions();

    if (hasPermission){
      var geofenceService = ref.read(geofenceServiceProvider);
      await geofenceService.startMonitoring();
    }

    if (!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GroupsScreen(showBack: false,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(showBack:false),
      body: AppPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Nazwa użytkownika",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _usernameController,
              enabled: !_isLoading,
              autocorrect: false,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () async => await signIn(context),
              icon: const Icon(Icons.login),
              label: const Text("Zaloguj się"),
            )
          ],
        ),
      )
    );
  }
}
