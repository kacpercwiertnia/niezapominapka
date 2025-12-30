import 'package:flutter/material.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/theme.dart';

class SelectionList extends StatelessWidget {
  final List<AppUser> value; // Wybrani użytkownicy
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
    return Column(
      children: availableOptions.map((user) {
        // Sprawdzamy, czy dany użytkownik jest na liście wybranych
        final isSelected = value.any((u) => u.id == user.id);

        return InkWell(
          onTap: () => _toggleUser(user, isSelected),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Customowy Checkbox
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleUser(user, isSelected),
                    activeColor: const Color(0xFF32465A), // Kolor ze zdjęcia
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.transparent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nazwa użytkownika
                Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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