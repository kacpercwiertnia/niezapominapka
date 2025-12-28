import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import '../../components/molecules/AppPage.dart';
import 'GroupsScreen.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  final bool showBack;

  const CreateGroupScreen ({super.key, required this.showBack});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController _groupnameController = TextEditingController();
  bool _isLoading = false;

  Future<void> createGroup(BuildContext context) async {
    if (!mounted) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupsScreen(showBack: false,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitle(showBack: widget.showBack),

      body: AppPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Nazwa grupy",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _groupnameController,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () async => await createGroup(context),
              icon: const Icon(Icons.login),
              label: const Text("Swtórz grupę"),
            )
          ],
        )
      ),
    );
  }
}