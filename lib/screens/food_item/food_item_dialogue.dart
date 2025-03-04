import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/dropdown/unit_of_measurement_dropdown_button.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodItemDialogue extends StatefulWidget {
  final bool isButton;
  final FoodItem? foodItem;
  const FoodItemDialogue({
    super.key,
    this.isButton = true,
    this.foodItem,
  });

  @override
  State<FoodItemDialogue> createState() => _FoodItemDialogueState();
}

class _FoodItemDialogueState extends State<FoodItemDialogue> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  UnitOfMeasureEnum uomValue = UnitOfMeasureEnum.g;

  @override
  void initState() {
    super.initState();
    if (widget.foodItem != null) {
      _nameController.text = widget.foodItem!.name;
      _quantityController.text = widget.foodItem!.quantity.toString();
      _caloriesController.text = widget.foodItem!.calories.toString();
      _proteinController.text = widget.foodItem!.protein.toString();
      _carbsController.text = widget.foodItem!.carbs.toString();
      _fatController.text = widget.foodItem!.fat.toString();
      uomValue = widget.foodItem!.uoM;
    }
  }

  void _clearTexts() {
    _nameController.clear();
    _quantityController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatController.clear();
  }

  Future<void> _addFoodItem(BuildContext context) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user == null) return;

      final quantityValue = double.tryParse(_quantityController.text);

      if (quantityValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid quantity');

        return;
      }

      final caloriesValue = double.tryParse(_caloriesController.text);

      if (caloriesValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid calories');

        return;
      }

      final proteinValue = double.tryParse(_proteinController.text);

      if (proteinValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid calories');

        return;
      }

      final carbsValue = double.tryParse(_carbsController.text);

      if (carbsValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid calories');

        return;
      }

      final fatValue = double.tryParse(_fatController.text);

      if (fatValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid calories');

        return;
      }

      final foodItem = widget.foodItem?.copyWith(
            name: _nameController.text,
            uoM: uomValue,
            quantity: quantityValue,
            calories: caloriesValue,
            protein: proteinValue,
            carbs: carbsValue,
            fat: fatValue,
          ) ??
          FoodItem(
            id: 0,
            createdAt: null,
            updatedAt: null,
            deletedAt: null,
            name: _nameController.text,
            uoM: uomValue,
            quantity: quantityValue,
            calories: caloriesValue,
            protein: proteinValue,
            carbs: carbsValue,
            fat: fatValue,
            userId: user.id,
          );

      final result = await Provider.of<FoodItemProvider>(context, listen: false)
          .save(foodItem);

      if (result) {
        _clearTexts();
        NavigationService.instance.pop();
      }
    } catch (ex) {
      ScaffoldMessengerService.instance
          .displayError('error upserting food item');
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
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 20,
                top: 20,
              ),
              height: 500,
              child: Provider.of<FoodItemProvider>(context, listen: false)
                      .isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
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
                        CustomTextField(
                          controller: _nameController,
                          label: 'name',
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        UnitOfMeasureDropdownButton(
                          context: context,
                          value: uomValue,
                          onSelected: (value) {
                            if (value == null) return;
                            setState(() {
                              uomValue = value;
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
                        CustomTextField(
                          controller: _caloriesController,
                          label: 'calories',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: _proteinController,
                          label: 'protein',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: _carbsController,
                          label: 'carb',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextField(
                          controller: _fatController,
                          label: 'fat',
                          keyboardType: TextInputType.number,
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
                                  _clearTexts();
                                },
                                child: const Text(
                                  'clear',
                                  style: TextStyles.white15Medium,
                                ),
                              ),
                              CustomOutlinedButton(
                                onPressed: () {
                                  setState(() {});
                                  _addFoodItem(context);
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
                  'add food item',
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
