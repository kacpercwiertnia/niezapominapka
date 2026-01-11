import 'package:flutter/material.dart';
import 'package:niezapominapka/features/auth/app_user.dart';

class SelectionList extends StatelessWidget {
  final List<AppUser> value;
  final void Function(List<AppUser>) onChange;
  final List<AppUser> availableOptions;

  const SelectionList({
    super.key,
    required this.value,
    required this.onChange,
    required this.availableOptions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: availableOptions.length,
      itemBuilder: (context, i) {
        final user = availableOptions[i];
        final isSelected = value.any((u) => u.id == user.id);

        return CheckboxListTile(
          value: isSelected,
          onChanged: (_) => _toggleUser(user, isSelected),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,

          activeColor: const Color(0xFF32465A),
          checkColor: Colors.white,

          title: Text(
            user.username,
            style: Theme.of(context).textTheme.bodyLarge
          ),
        );
      },
    );
  }

  void _toggleUser(AppUser user, bool isSelected) {
    List<AppUser> newList = List.from(value);
    if (isSelected) {
      newList.removeWhere((u) => u.id == user.id);
    } else {
      newList.add(user);
    }
    onChange(newList);
  }
}