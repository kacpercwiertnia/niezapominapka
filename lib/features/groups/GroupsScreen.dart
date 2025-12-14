import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/auth/CurrentUser.dart';
import 'GroupCard.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen ({super.key});

  @override
  ConsumerState<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  final List<String> groups = const [
    "Pokój 501",
    "Urodziny Ani",
    "Sylwester",
  ];

  @override
  Widget build(BuildContext context) {
    var curUser = ref.read(currentUserProvider.notifier);

    return Scaffold(
      appBar: Apptitle(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView.separated(
            itemBuilder: (context, index) {
              final name = groups[index];
              return GroupCard(title: name);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: groups.length
          )
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add, size: 30,),
      ),
    );
  }
}
