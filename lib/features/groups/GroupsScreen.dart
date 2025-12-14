import 'package:flutter/material.dart';
import 'GroupCard.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen ({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<String> groups = const [
    "Pokój 501",
    "Urodziny Ani",
    "Sylwester",
  ];

  @override
  Widget build(BuildContext context) {
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
