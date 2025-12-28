import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niezapominapka/features/group/GroupSection.dart';

import '../../theme.dart';

class SectionButtons extends StatelessWidget {
  final GroupSection currentSection;
  final void Function(GroupSection) setSection;

  SectionButtons({super.key, required this.currentSection, required this.setSection});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: currentSection == GroupSection.Expenses
              ? AppTheme.selectedElevatedButtonStyle
              : AppTheme.unselectedElevatedButtonStyle,
          onPressed: () => setSection(GroupSection.Expenses),
          child: Text("Wydatki"),
        ),
        const SizedBox(width: 8,),
        ElevatedButton(
          style: currentSection == GroupSection.ShopList
              ? AppTheme.selectedElevatedButtonStyle
              : AppTheme.unselectedElevatedButtonStyle,
          onPressed: () => setSection(GroupSection.ShopList),
          child: Text("Lista zakupów"),
        ),
        const SizedBox(width: 8,),
        ElevatedButton(
          style: currentSection == GroupSection.Bills
              ? AppTheme.selectedElevatedButtonStyle
              : AppTheme.unselectedElevatedButtonStyle,
          onPressed: () => setSection(GroupSection.Bills),
          child: Text("Rachunki"),
        ),
      ],
    );
  }
}