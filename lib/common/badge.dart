import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String badge;

  Badge({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
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
