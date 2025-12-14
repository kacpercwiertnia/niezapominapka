import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/db_providers.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _controller = TextEditingController();
  bool _isSaving = false;
  bool _canSubmit = false;

  Future<void> _onCreatePressed() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brak zalogowanego użytkownika')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      await db.createGroupForUser(userId: user.id, name: name);

      if (!mounted) return;
      Navigator.of(context).pop(true); // wracamy z info, że grupa powstała
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się utworzyć grupy: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // czarne tło ekranu
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // nagłówek aplikacji na czarnym tle
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                'Niezapominapka',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // główna "karta" na ciemnym niebieskim tle
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor, // Twój ciemny niebieski
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // strzałka + tytuł "Stwórz grupę"
                      SizedBox(
                        height: 48,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const Center(
                              child: Text(
                                'Stwórz grupę',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Center(
                        child: Text(
                          'Nazwa grupy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            _canSubmit = value.trim().isNotEmpty;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (_canSubmit && !_isSaving) {
                            _onCreatePressed();
                          }
                        },
                        decoration: const InputDecoration(
                          // wygląd samego pola bierze się z globalnego
                          // InputDecorationTheme (ciemna "belka")
                          labelText: '',
                        ),
                      ),

                      const Spacer(),

                      // przycisk na dole, wciąż na ciemnym niebieskim tle
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                          _canSubmit && !_isSaving ? _onCreatePressed : null,
                          icon: _isSaving
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                            CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.add),
                          label: Text(
                            _isSaving ? 'Tworzenie...' : 'Stwórz grupę',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
