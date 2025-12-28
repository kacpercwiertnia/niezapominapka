import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/GroupView.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final Group group;

  const GroupScreen({super.key, required this.group});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  GroupView curView = GroupView.Expenses;
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: AppPage(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () => setState(() =>
                    curView = GroupView.Expenses
                  ),
                  child: Text("Wydatki"),
              ),
              ElevatedButton(
                onPressed: () => setState(() =>
                curView = GroupView.ShopList
                ),
                child: Text("Lista zakupów"),
              ),
              ElevatedButton(
                onPressed: () => setState(() =>
                curView = GroupView.Bills
                ),
                child: Text("Rachunki"),
              ),
            ],
          )
      )
    );
  }
}