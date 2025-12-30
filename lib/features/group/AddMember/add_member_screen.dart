import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  final Group group;
  final bool showBack;

  const AddMemberScreen({super.key, required this.group, required this.showBack});

  String get inviteUrl => 'niezapominapka://join?code=${group.id}';

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: AppPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Prześlij link do grupy",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            TextField(
              readOnly: true,
              controller: TextEditingController(text: widget.inviteUrl),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: widget.inviteUrl));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Skopiowano link')),
                          );
                        }
                      },
                      icon: const Icon(Icons.copy))
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Pokaż kod QR grupy",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            QrImageView(
              data: widget.inviteUrl,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
            ),
          ],
        ),
      ),
    );
  }
}