import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'GroupCard.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import '../../components/molecules/AppPage.dart';
import 'CreateGroupScreen.dart';
import 'package:niezapominapka/core/db/repositories/GroupRepository.dart';
import 'package:niezapominapka/features/groups/group_model.dart';

final userGroupsProvider = FutureProvider.autoDispose<List<Group>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroupsForUserId(user.id!);
});

class GroupsScreen extends ConsumerStatefulWidget {
  final bool showBack;

  const GroupsScreen ({super.key, required this.showBack});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  bool _menuOpen = false;
  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(userGroupsProvider);

    return Scaffold(
      appBar: AppTitle(showBack: widget.showBack),

      body: Stack(
        children: [
          AppPage(
            child: groupsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("Błąd: $e")),
              data: (groups) {
                if (groups.isEmpty) {
                  return const Center(child: Text("Nie masz żadnych grup"));
                }

                return ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final g = groups[index];
                    return GroupCard(title: g.name);
                  },
                );
              },
            ),
          ),
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.black26),
              ),
            ),

          BottomActionBanner(
            visible: _menuOpen,
            onCreateGroup: () {
              _toggleMenu();
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupScreen(showBack: true,)));
            },
            onJoinGroup: () {
              _toggleMenu();
              // TODO: akcja
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            _menuOpen ? Icons.close : Icons.add,
            key: ValueKey(_menuOpen),
            size: 30,
          ),
        ),
      ),
    );
  }
}

class BottomActionBanner extends StatelessWidget {
  final bool visible;
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinGroup;

  const BottomActionBanner({
    required this.visible,
    required this.onCreateGroup,
    required this.onJoinGroup,
  });

  @override
  Widget build(BuildContext context){
    const double bannerHeight = 120;
    const double bottomPadding = 120;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      left: 16,
      right: 16,
      bottom: visible ? bottomPadding : -bannerHeight,
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ActionRow(
              icon: Icons.add,
              title: "Stwórz grupę",
              onTap: onCreateGroup,
            ),
            ActionRow(
              icon: Icons.link,
              title: "Dołącz do grupy",
              onTap: onJoinGroup,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}