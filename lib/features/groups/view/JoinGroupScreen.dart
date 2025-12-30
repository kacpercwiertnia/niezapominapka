import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/core/db/repositories/GroupRepository.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'package:niezapominapka/features/groups/model/user_group_provider.dart';
import '../../../components/molecules/AppPage.dart';
import 'GroupsScreen.dart';

class JoinGroupScreen extends ConsumerStatefulWidget {
  final bool showBack;

  const JoinGroupScreen ({super.key, required this.showBack});

  @override
  ConsumerState<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  final MobileScannerController _mobileScannerController = MobileScannerController();
  final TextEditingController _groupLinkController = TextEditingController();
  bool _isLoading = false;

  int? extractCodeAsInt(String groupLink) {
    final re = RegExp(r'^niezapominapka://join\?code=(\d+)(?:&.*)?$');
    final match = re.firstMatch(groupLink);
    if (match == null) return null;

    final codeStr = match.group(1);
    return int.tryParse(codeStr ?? '');
  }

  Future<void> joinGroup(BuildContext context, {String? code}) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _mobileScannerController.stop();

    var curUserId = ref.watch(currentUserProvider)?.id;
    if (curUserId == null){
      setState(() => _isLoading = false);
      await _mobileScannerController.stop();
      return; //TODO: nwm co tu ma byc to chyba niemozliwe
    }

    var groupLink = code == null ? _groupLinkController.text.trim() : code;
    if (groupLink.isEmpty) {
      setState(() => _isLoading = false);
      await _mobileScannerController.stop();
      return; //TODO: no tu bedzie popup
    }

    var groupId = extractCodeAsInt(groupLink);

    if (groupId == null) {
      setState(() => _isLoading = false);
      await _mobileScannerController.stop();
      return; //TODO: popup, że invalid code
    }

    var groupRepo = ref.watch(groupRepositoryProvider);

    var recordId = await groupRepo.addUserToGroup(curUserId, groupId);

    if (recordId == null) {
      setState(() => _isLoading = false);
      await _mobileScannerController.stop();
      return; //TODO: popup, że nie udało się dodać do grupy/grupa nie istnieje
    }

    ref.invalidate(userGroupsProvider);
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
                "Podaj link do grupy",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _groupLinkController,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 14),
              Text(
                "Zeskanuj kod QR grupy",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              MobileScanner(
                controller: _mobileScannerController,
                onDetect: (capture) async {
                  if (_isLoading) return;
                  return await joinGroup(context, code: capture.barcodes.firstOrNull?.rawValue);
                },
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () async => await joinGroup(context),
                icon: const Icon(Icons.link),
                label: const Text("Dołącz do grupy"),
              )
            ],
          )
      ),
    );
  }
}