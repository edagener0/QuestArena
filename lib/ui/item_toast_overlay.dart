import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class ItemToastOverlay extends ConsumerWidget {
  const ItemToastOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effect = ref.watch(itemEffectProvider);

    if (effect == null) return const SizedBox.shrink();

    Color bgColor;
    IconData icon;
    
    if (!effect.success || effect.action == 'error') {
      bgColor = const Color(0xFFFF6600); // Orange for errors/warnings
      icon = Icons.error_outline;
    } else {
      switch (effect.action) {
        case 'pickup':
          bgColor = const Color(0xFF00FF88); // Green
          icon = Icons.add_circle_outline;
          break;
        case 'use':
          bgColor = const Color(0xFF00BFFF); // Blue
          icon = Icons.auto_awesome;
          break;
        case 'trap_triggered':
          bgColor = const Color(0xFFFF4444); // Red
          icon = Icons.warning_amber_rounded;
          break;
        default:
          bgColor = const Color(0xFFE94560); // Pink/Red fallback
          icon = Icons.info_outline;
      }
    }

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  effect.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
