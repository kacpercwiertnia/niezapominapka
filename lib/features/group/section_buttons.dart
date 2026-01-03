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
        Expanded(child: _btn(GroupSection.Expenses, 'Wydatki')),
        const SizedBox(width: 8),
        Expanded(child: _btn(GroupSection.ShopList, 'Lista zakupów')),
        const SizedBox(width: 8),
        Expanded(child: _btn(GroupSection.Bills, 'Rachunki')),
      ],
    );
  }

  Widget _btn(GroupSection section, String label) {
    final baseStyle = currentSection == section
        ? AppTheme.selectedElevatedButtonStyle
        : AppTheme.unselectedElevatedButtonStyle;

    return ElevatedButton(
      style: baseStyle.copyWith(
        // mniejszy padding tylko dla tych “tabsów”
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        ),
        // pozwala zejść z minimalną szerokością przycisku
        minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => setSection(section),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, maxLines: 1),
      ),
    );
  }
}