import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../providers/activity_fields_provider.dart';

class ProductivityLvlField extends HookConsumerWidget {
  const ProductivityLvlField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int level = ref.watch(
      activityFieldsNotifierProvider
          .select((ActivityEntity a) => a.productivityLevel),
    );

    return ListTile(
      title: const Text('Productivity level'),
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: level > 1
                ? () => ref
                    .read(activityFieldsNotifierProvider.notifier)
                    .productivityLevel = level - 1
                : null,
          ),
          Text('$level', style: Theme.of(context).textTheme.bodyMedium),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: level < 5
                ? () => ref
                    .read(activityFieldsNotifierProvider.notifier)
                    .productivityLevel = level + 1
                : null,
          ),
        ],
      ),
    );
  }
}
