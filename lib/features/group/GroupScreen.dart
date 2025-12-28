import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/GroupSection.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';
import 'package:niezapominapka/theme.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final Group group;

  const GroupScreen({super.key, required this.group});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  GroupSection curView = GroupSection.Expenses;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: AppPage(
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: curView == GroupSection.Expenses
                          ? AppTheme.selectedElevatedButtonStyle
                          : AppTheme.unselectedElevatedButtonStyle,
                      onPressed: () => setState(() =>
                      curView = GroupSection.Expenses
                      ),
                      child: Text("Wydatki"),
                    ),
                    const SizedBox(width: 8,),
                    ElevatedButton(
                      style: curView == GroupSection.ShopList
                          ? AppTheme.selectedElevatedButtonStyle
                          : AppTheme.unselectedElevatedButtonStyle,
                      onPressed: () => setState(() =>
                      curView = GroupSection.ShopList
                      ),
                      child: Text("Lista zakupów"),
                    ),
                    const SizedBox(width: 8,),
                    ElevatedButton(
                      style: curView == GroupSection.Bills
                          ? AppTheme.selectedElevatedButtonStyle
                          : AppTheme.unselectedElevatedButtonStyle,
                      onPressed: () => setState(() =>
                      curView = GroupSection.Bills
                      ),
                      child: Text("Rachunki"),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                GroupSectionRenderer(selectedSection: curView)
              ]
          )
      )
    );
  }
}