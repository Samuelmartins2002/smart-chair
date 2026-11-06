import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../history/presentation/history_controller.dart';

class RecentEventsCard extends ConsumerWidget {
  const RecentEventsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(historyProvider).take(3).toList();

    return SectionCard(
      title: 'Últimos eventos',
      trailing: TextButton(
        onPressed: () => context.go('/history'),
        child: const Text('Ver histórico →'),
      ),
      child: events.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Nenhum evento ainda.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : Column(
              children: [
                for (final e in events)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 52,
                          child: Text(e.hhmm,
                              style:
                                  const TextStyle(color: AppColors.textMuted)),
                        ),
                        Expanded(
                          child: Text(e.title,
                              style: const TextStyle(color: AppColors.navy)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}