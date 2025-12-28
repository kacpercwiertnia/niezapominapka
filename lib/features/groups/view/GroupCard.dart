import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;

  const GroupCard ({super.key, required this.title});

  @override
  Widget build(BuildContext context){
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
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
