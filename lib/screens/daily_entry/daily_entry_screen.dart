import 'package:calories_app/models/daily_entry.dart';
import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/screens/daily_entry/daily_entry_dialogue.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/helper/confirmation_dialogue.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class _View {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const _View({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  int get hashCode =>
      super.hashCode ^ Object.hash(calories, protein, carbs, fat);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntry && hashCode == other.hashCode);
}

class DailyEntryScreen extends StatelessWidget {
  const DailyEntryScreen({super.key});

  Future<void> _onTileLongPress(
    BuildContext context,
    DailyEntry dailyEntry,
    FoodItem? foodItem,
  ) async {
    bool result = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialogue(
        title: 'Delete Food Item',
        content: 'Are you sure you want to delete entry',
        item:
            '${foodItem?.name} on ${DateService.toNormalDate(date: dailyEntry.date)}',
      ),
    );

    if (result) {
      Provider.of<DailyEntryProvider>(context, listen: false)
          .remove(dailyEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await Provider.of<DailyEntryProvider>(context, listen: false).getAll();
      },
      child: Consumer2<DailyEntryProvider, FoodItemProvider>(
        builder: (context, dailyEntry, foodItem, child) => Column(
          children: [
            Expanded(
              child: Visibility(
                visible: dailyEntry.entries.isNotEmpty,
                replacement: const Center(child: Text('no entries')),
                child: GroupedListView(
                  elements: dailyEntry.entries,
                  groupBy: (e) => e.date,
                  groupSeparatorBuilder: (DateTime groupByValue) {
                    final dailyValues = dailyEntry.entries
                        .where(
                          (e) => e.date == groupByValue,
                        )
                        .toList();

                    final totalCalories = dailyValues.map((e) {
                      final item = foodItem.items
                          .firstWhereOrNull((i) => i.id == e.foodItemsId);

                      return _View(
                        calories: (item?.calories ?? 0) * e.quantity,
                        protein: (item?.protein ?? 0) * e.quantity,
                        carbs: (item?.carbs ?? 0) * e.quantity,
                        fat: (item?.fat ?? 0) * e.quantity,
                      );
                    }).toList();

                    final totals = totalCalories.fold(
                      const _View(calories: 0, protein: 0, carbs: 0, fat: 0),
                      (previous, current) => _View(
                        calories: previous.calories + current.calories,
                        protein: previous.protein + current.protein,
                        carbs: previous.carbs + current.carbs,
                        fat: previous.fat + current.fat,
                      ),
                    );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Divider(
                          indent: 8,
                          endIndent: 8,
                        ),
                        Text(
                          DateService.toNormalDate(
                            date: groupByValue.toLocal(),
                          ),
                          style: TextStyles.white20Bold,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'totals: cals: ${totals.calories.toStringAsFixed(2)}, p: ${totals.protein.toStringAsFixed(2)}, f: ${totals.fat.toStringAsFixed(2)}, c: ${totals.carbs.toStringAsFixed(2)}',
                          style: TextStyles.white15Medium,
                        ),
                        const Divider(
                          indent: 50,
                          endIndent: 50,
                        ),
                      ],
                    );
                  },
                  itemBuilder: (context, DailyEntry element) {
                    final item = foodItem.items.firstWhereOrNull(
                      (e) => e.id == element.foodItemsId,
                    );

                    return ListTile(
                      onLongPress: () {
                        _onTileLongPress(context, element, item);
                      },
                      title: Text(
                        '${item?.name}',
                        style: TextStyles.white15Medium,
                      ),
                      subtitle: Text(
                        'cals: ${(item?.calories ?? 0) * element.quantity}, p:${(item?.protein ?? 0) * element.quantity}, f:${(item?.fat ?? 0) * element.quantity}, c:${(item?.carbs ?? 0) * element.quantity}',
                        style: TextStyles.white15Medium,
                      ),
                      trailing: DailyEntryDialogue(
                        isButton: false,
                        dailyEntry: element,
                        key: Key(element.id.toString()),
                      ),
                    );
                  },
                  useStickyGroupSeparators: false,
                  floatingHeader: true,
                  order: GroupedListOrder.DESC,
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DailyEntryDialogue(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
