import 'package:flutter/material.dart';

class CountCard extends StatelessWidget {
  final int pending;
  final int inProgress;
  final int completed;

  const CountCard({
    super.key,
    required this.pending,
    required this.inProgress,
    required this.completed,
  });

  Widget _buildCount(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCount("Pending", pending, theme.colorScheme.error),
        _buildCount("In Progress", inProgress, Colors.amber.shade700),
        _buildCount("Completed", completed, Colors.green.shade600),
      ],
    );
  }
}
