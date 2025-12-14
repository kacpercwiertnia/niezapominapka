import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/db_providers.dart';
import 'group_model.dart';
import 'create_group_screen.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> with TickerProviderStateMixin{
  bool _showAddOptions = false;

  Future<void> _openCreateGroupScreen() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const CreateGroupScreen(),
      ),
    );

    if (created == true) {
      // odśwież listę grup po powrocie
      ref.invalidate(userGroupsProvider);
    }

    setState(() {
      _showAddOptions = false; // schowaj panel po powrocie
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(userGroupsProvider);
    final cardColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // góra + lista grup
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Niezapominapka',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: groupsAsync.when(
                      data: (groups) => _GroupsList(
                        groups: groups,
                        cardColor: cardColor,
                      ),
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      error: (err, stack) =>
                          Center(child: Text('Błąd wczytywania grup: $err')),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // PANEL + KÓŁKO
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // panel ponad kółkiem
                  _buildAnimatedPanel(cardColor),

                  // kółko, które stoi w miejscu
                  _buildFab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedPanel(Color cardColor) {
    // ile "nad" środkiem kółka ma wisieć panel
    const double bottomOffset = 64 + 12; // średnica kółka + odstęp

    return IgnorePointer(
      ignoring: !_showAddOptions,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: _showAddOptions ? Offset.zero : const Offset(0, 0.2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _showAddOptions ? 1 : 0,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: bottomOffset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionCard(
                  color: cardColor,
                  icon: Icons.add,
                  label: 'Stwórz grupę',
                  onTap: _openCreateGroupScreen,
                ),
                const SizedBox(height: 8),
                _ActionCard(
                  color: cardColor,
                  icon: Icons.link,
                  label: 'Dołącz do grupy',
                  onTap: () {
                    // TODO: dołączanie do grupy
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    const bgColor = Color(0xFF062335); // dobierz pod swój theme

    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showAddOptions = !_showAddOptions;
          });
        },
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Icon(
                _showAddOptions ? Icons.close : Icons.add,
                key: ValueKey(_showAddOptions),
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  final List<Group> groups;
  final Color cardColor;

  const _GroupsList({
    required this.groups,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(
        child: Text(
          'Nie masz jeszcze żadnych grup.\n'
              'Stwórz nową za pomocą przycisku + na dole.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = groups[index];
        return _GroupCard(
          title: group.name,
          color: cardColor,
          onTap: () {
            // TODO: przejście do ekranu szczegółów grupy
          },
        );
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  const _GroupCard({
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
