import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class FoodItemAutocompleteDropdown extends Autocomplete<FoodItem> {
  FoodItemAutocompleteDropdown({
    super.key,
    required List<FoodItem> foodItems,
    void Function(FoodItem foodItem)? onSelected,
    TextEditingValue? initialValue,
  }) : super(
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return CustomTextField(
              label: 'food item',
              focusNode: focusNode,
              controller: textEditingController,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            );
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            return foodItems.where((FoodItem option) {
              return option.name.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: onSelected,
          initialValue: initialValue,
          displayStringForOption: (FoodItem f) =>
              '${f.name} - ${f.quantity}${f.uoM.name}',
          optionsMaxHeight: 100,
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: 260,
                height: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: ListView.separated(
                  itemCount: options.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onSelected(options.toList()[index]),
                      title: Text(
                        '${options.toList()[index].name} - ${options.toList()[index].quantity}${options.toList()[index].uoM.name}',
                      ),
                      titleAlignment: ListTileTitleAlignment.center,
                    );
                  },
                ),
              ),
            ),
          ),
        );
}
