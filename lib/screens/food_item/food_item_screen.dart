import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/screens/food_item/food_item_dialogue.dart';
import 'package:calories_app/service/helper/confirmation_dialogue.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodItemScreen extends StatefulWidget {
  const FoodItemScreen({super.key});

  @override
  State<FoodItemScreen> createState() => _FoodItemScreenState();
}

class _FoodItemScreenState extends State<FoodItemScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onTileLongPress(BuildContext context, FoodItem foodItem) async {
    bool result = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialogue(
        title: 'Delete Food Item',
        content: 'Are you sure you want to delete entry',
        item: foodItem.name,
      ),
    );

    if (result) {
      Provider.of<FoodItemProvider>(context, listen: false).remove(foodItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await Provider.of<FoodItemProvider>(context, listen: false).getAll();
      },
      child: Consumer<FoodItemProvider>(
        builder: (context, value, child) {
          final foodItems = value.items
              .where(
                (e) =>
                    (_controller.text == '' ||
                        e.name.toLowerCase().contains(
                              _controller.text.toLowerCase(),
                            )) ||
                    (_controller.text == '' ||
                        e.calories.toString().toLowerCase().contains(
                              _controller.text.toLowerCase(),
                            )),
              )
              .toList()
            ..sort(
              (a, b) => a.name.compareTo(b.name),
            );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  label: 'search',
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                  suffixIcon: _controller.text == '' || _controller.text.isEmpty
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
              ),
              Expanded(
                child: Provider.of<FoodItemProvider>(context, listen: false)
                        .isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: foodItems.length,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.white,
                            endIndent: 20,
                            indent: 20,
                          );
                        },
                        itemBuilder: (context, index) {
                          final item = foodItems[index];

                          return ListTile(
                            onLongPress: () {
                              _onTileLongPress(context, item);
                            },
                            title: Text(
                              '${item.name} - ${item.quantity}${item.uoM.name}',
                              style: TextStyles.white15Medium,
                            ),
                            subtitle: Text(
                              'cals ${item.calories}, p ${item.protein}, c ${item.carbs}, f ${item.fat}',
                            ),
                            trailing: FoodItemDialogue(
                              foodItem: item,
                              isButton: false,
                            ),
                          );
                        },
                      ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FoodItemDialogue(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
