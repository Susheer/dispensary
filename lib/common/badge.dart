import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String badge;

  Badge({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(115, 255, 235, 59),
        borderRadius:
            BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class BadgeContainer extends StatelessWidget {
  final List<String> badges;

  const BadgeContainer({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: badges.map((badge) {
        return Badge(badge: badge);
      }).toList(),
    );
  }
}
