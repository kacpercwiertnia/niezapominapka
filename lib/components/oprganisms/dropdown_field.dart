import 'package:flutter/material.dart';
import 'package:niezapominapka/features/auth/app_user.dart';
import 'package:niezapominapka/theme.dart';

class DropdownField extends StatelessWidget {
  final String? value; // Nazwa wybranego użytkownika
  final void Function(AppUser) onChange;
  final List<AppUser> availableOptions;

  const DropdownField({
    super.key,
    required this.value,
    required this.onChange,
    required this.availableOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Znajdujemy obiekt AppUser na podstawie stringa 'value'
    // Zakładamy, że value to nazwa użytkownika (u.name)
    final AppUser? selectedUser = availableOptions.cast<AppUser?>().firstWhere(
          (u) => u?.username == value,
      orElse: () => null,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg, // Twój ciemny kolor z motywu
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AppUser>(
          value: selectedUser,
          isExpanded: true,
          // Customowa strzałka po lewej
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          iconSize: 32,
          dropdownColor: AppTheme.cardBg,
          // To sprawia, że wybrany element wygląda tak jak na zdjęciu
          selectedItemBuilder: (BuildContext context) {
            return availableOptions.map<Widget>((AppUser user) {
              return Center(
                child: Text(
                  user.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList();
          },
          // To są opcje po rozwinięciu listy
          items: availableOptions.map((AppUser user) {
            return DropdownMenuItem<AppUser>(
              value: user,
              child: Text(
                user.username,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (AppUser? newUser) {
            if (newUser != null) {
              onChange(newUser);
            }
          },
        ),
      ),
    );
  }
}