import 'package:flutter/material.dart';

class DPadControls extends StatelessWidget {
  final Function(String direction) onMove;

  const DPadControls({
    super.key,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up
        _DirectionButton(
          icon: Icons.keyboard_arrow_up,
          onPressed: () => onMove('north'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left
            _DirectionButton(
              icon: Icons.keyboard_arrow_left,
              onPressed: () => onMove('west'),
            ),
            // Center empty space
            const SizedBox(width: 36, height: 36),
            // Right
            _DirectionButton(
              icon: Icons.keyboard_arrow_right,
              onPressed: () => onMove('east'),
            ),
          ],
        ),
        // Down
        _DirectionButton(
          icon: Icons.keyboard_arrow_down,
          onPressed: () => onMove('south'),
        ),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _DirectionButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0F3460)),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF53CFFF),
          size: 32,
        ),
      ),
    );
  }
}
