import 'package:flutter/material.dart';

class SettingsInkwell extends StatelessWidget {
  final String settingName;
  final VoidCallback onTap;
  final IconData icon;

  const SettingsInkwell({
    super.key,
    required this.settingName,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      settingName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Icon(icon),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
