import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool compact;

  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(compact ? 10 : 16),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 17 : 20,
              letterSpacing: compact ? 0.8 : 1,
            ),
          ),

          SizedBox(height: compact ? 6 : 14),

          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
