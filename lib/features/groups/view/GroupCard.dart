import 'package:flutter/material.dart';
import 'package:niezapominapka/features/group/GroupScreen.dart';

import '../model/group_model.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  const GroupCard ({super.key, required this.group});

  void onTap(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GroupScreen(group: group)));
  }

  @override
  Widget build(BuildContext context){
    return Card(
      child: InkWell(
        onTap: () => onTap(context),
        splashColor: Colors.white.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Icon(Icons.chevron_right, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
