import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../groups/model/group_model.dart';

class GroupActionMenu extends StatelessWidget {
  final Group group;
  final VoidCallback onAddExpense;
  final VoidCallback onAddProducts;
  final VoidCallback onAddPerson;
  final VoidCallback closeMenu;
  final bool isMenuOpen;

  const GroupActionMenu({super.key,
    required this.group,
    required this.onAddExpense,
    required this.onAddProducts,
    required this.onAddPerson,
    required this.closeMenu,
    required this.isMenuOpen
  });

  @override
  Widget build(BuildContext context){
    const double bannerHeight = 180;
    const double bottomPadding = 100;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      left: 16,
      right: 16,
      bottom: isMenuOpen ? bottomPadding : -bannerHeight,
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            GroupDetailsActionRow(
              icon: Icons.money,
              title: "Dodaj rozliczenie",
              onTap: onAddExpense,
            ),
            GroupDetailsActionRow(
              icon: Icons.shopping_cart,
              title: "Dodaj brakujące produkty",
              onTap: onAddProducts,
            ),
            GroupDetailsActionRow(
              icon: Icons.person_add,
              title: "Zaproś do grupy",
              onTap: onAddPerson,
            ),
          ],
        ),
      ),
    );
  }
}

class GroupDetailsActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const GroupDetailsActionRow({
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