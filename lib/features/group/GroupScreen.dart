import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/GroupSection.dart';
import 'package:niezapominapka/features/group/section_buttons.dart';
import 'package:niezapominapka/features/groups/model/group_model.dart';
import 'package:niezapominapka/theme.dart';

import 'GroupSectionRenderer.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final Group group;

  const GroupScreen({super.key, required this.group});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  GroupSection curView = GroupSection.Expenses;

  void setSection(GroupSection section){
    setState(() => curView = section);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: AppPage(
          child: Column(
              children: [
                SectionButtons(currentSection: curView, setSection: setSection),
                const SizedBox(height: 20,),
                GroupSectionRenderer(selectedSection: curView, currentGroup: widget.group,)
              ]
          )
      )
    );
  }
}