import 'package:calories_app/models/daily_entry.dart';
import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/date_dialog/date_dialog.dart';
import 'package:calories_app/widget/dropdown/food_item_autocomplete_dropdown.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyEntryDialogue extends StatefulWidget {
  final bool isButton;
  final DailyEntry? dailyEntry;
  const DailyEntryDialogue({
    super.key,
    this.isButton = true,
    this.dailyEntry,
  });

  @override
  State<DailyEntryDialogue> createState() => _DailyEntryDialogueState();
}

class _DailyEntryDialogueState extends State<DailyEntryDialogue> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TextEditingValue? _initialValue;

  DateTime? _weighDate;
  FoodItem? _selectedFoodItem;

  @override
  void initState() {
    super.initState();
    if (widget.dailyEntry == null) return;
    _weighDate = widget.dailyEntry!.date;
    _quantityController.text = widget.dailyEntry!.quantity.toString();
    _dateController.text =
        DateService.toNormalDate(date: widget.dailyEntry!.date);
    final items = Provider.of<FoodItemProvider>(context, listen: false).items;
    final selectedItem =
        items.firstWhereOrNull((i) => i.id == widget.dailyEntry!.foodItemsId);
    _selectedFoodItem = selectedItem;
    _initialValue = TextEditingValue(
      text: selectedItem?.name ?? '',
    );
  }

  Future<void> _addDate(BuildContext context) async {
    final date = await dateDialogBuilder(context, null);

    if (date == null) return;

    setState(() {
      _weighDate = date;
      _dateController.text = DateService.toNormalDate(date: date);
    });
  }

  Future<void> _addDailyEntry(BuildContext context) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user == null) return;

      if (_selectedFoodItem == null) {
        ScaffoldMessengerService.instance.displayError('select a food item');

        return;
      }

      final quantity = double.tryParse(_quantityController.text);

      if (quantity == null) {
        ScaffoldMessengerService.instance.displayError('add a valid quantity');

        return;
      }

      if (_weighDate == null) {
        ScaffoldMessengerService.instance.displayError('add a valid date');

        return;
      }

      final dailyEntry = widget.dailyEntry?.copyWith(
            date: _weighDate!,
            quantity: quantity,
            foodItemsId: _selectedFoodItem!.id,
          ) ??
          DailyEntry(
            id: 0,
            createdAt: null,
            updatedAt: null,
            deletedAt: null,
            date: _weighDate!,
            quantity: quantity,
            userId: user.id,
            foodItemsId: _selectedFoodItem!.id,
          );

      final result =
          await Provider.of<DailyEntryProvider>(context, listen: false)
              .save(dailyEntry);

      if (result) {
        _quantityController.clear();
        _dateController.clear();
        NavigationService.instance.pop();
      }
    } catch (ex) {
      ScaffoldMessengerService.instance
          .displayError('error upserting daily entry');
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 350,
              child: Provider.of<DailyEntryProvider>(context, listen: false)
                      .isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                NavigationService.instance.pop();
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                          ],
                        ),
                        FoodItemAutocompleteDropdown(
                          foodItems: Provider.of<FoodItemProvider>(
                            context,
                            listen: false,
                          ).items,
                          initialValue: _initialValue,
                          onSelected: (foodItem) {
                            setState(() {
                              _selectedFoodItem = foodItem;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: _quantityController,
                          label: 'quantity',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Material(
                          child: InkWell(
                            onTap: () {
                              _addDate(context);
                            },
                            child: CustomTextField(
                              enabled: false,
                              controller: _dateController,
                              label: 'date',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _quantityController.clear();
                                  _dateController.clear();
                                },
                                child: const Text(
                                  'clear',
                                  style: TextStyles.white15Medium,
                                ),
                              ),
                              CustomOutlinedButton(
                                onPressed: () {
                                  setState(() {});
                                  _addDailyEntry(context);
                                },
                                child: const Text(
                                  'save',
                                  style: TextStyles.white15Medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isButton
        ? CustomOutlinedButton(
            onPressed: () {
              _dialogBuilder(context);
            },
            child: const Row(
              children: [
                Text(
                  'add daily entry',
                  style: TextStyles.white15Medium,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ],
            ),
          )
        : IconButton(
            onPressed: () {
              _dialogBuilder(context);
            },
            icon: const Icon(
              Icons.edit,
            ),
          );
  }
}
