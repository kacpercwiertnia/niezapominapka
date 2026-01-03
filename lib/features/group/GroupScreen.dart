import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/components/molecules/AppPage.dart';
import 'package:niezapominapka/components/molecules/AppTitle.dart';
import 'package:niezapominapka/features/group/AddMember/add_member_screen.dart';
import 'package:niezapominapka/features/group/GroupSection.dart';
import 'package:niezapominapka/features/group/expenses/add_expense_screen.dart';
import 'package:niezapominapka/features/group/group_action_menu.dart';
import 'package:niezapominapka/features/group/section_buttons.dart';
import 'package:niezapominapka/features/group/shoplist/add_products_screen.dart';
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

  bool _menuOpen = false;
  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);
  void _closeMenu() => setState(() => _menuOpen = false);

  void _onAddExpense(){
    _closeMenu();
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen(showBack: true, group: widget.group)));
  }

  void _onAddProducts(){
    _closeMenu();
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductsScreen(showBack: true, group: widget.group)));
  }

  void _onAddPerson(){
    _closeMenu();
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemberScreen(showBack: true, group: widget.group)));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppTitle(showBack: true),
      body: Stack(
        children: [
          AppPage(
              child: Column(
                  children: [
                    Text(
                      widget.group.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    SectionButtons(
                      currentSection: curView,
                      setSection: setSection
                    ),
                    const SizedBox(height: 14),
                    Expanded(child: GroupSectionRenderer(
                      selectedSection: curView,
                      currentGroup: widget.group,)
                    )
                  ]
              )
          ),
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleMenu,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.black26),
              ),
            ),
          GroupActionMenu(group: widget.group,
              onAddExpense: _onAddExpense,
              onAddProducts: _onAddProducts,
              onAddPerson: _onAddPerson,
              closeMenu: _closeMenu,
              isMenuOpen: _menuOpen)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMenu,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            _menuOpen ? Icons.close : Icons.add,
            key: ValueKey(_menuOpen),
            size: 30,
          ),
        ),
      ),
    );
  }
}