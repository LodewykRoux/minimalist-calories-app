import 'package:calories_app/models/weight.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/date_dialog/date_dialog.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightDialogue extends StatefulWidget {
  final bool isButton;
  final Weight? weight;
  const WeightDialogue({
    super.key,
    this.isButton = true,
    this.weight,
  });

  @override
  State<WeightDialogue> createState() => _WeightDialogueState();
}

class _WeightDialogueState extends State<WeightDialogue> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _weighDate;

  @override
  void initState() {
    super.initState();
    if (widget.weight != null) {
      _weighDate = widget.weight!.date;
      _weightController.text = widget.weight!.weight.toString();
      _dateController.text =
          DateService.toNormalDate(date: widget.weight!.date);
    }
  }

  Future<void> _addDate(BuildContext context) async {
    final date = await dateDialogBuilder(context, null);

    if (date == null) return;

    setState(() {
      _weighDate = date;
      _dateController.text = DateService.toNormalDate(date: date);
    });
  }

  Future<void> _addWeight(BuildContext context) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user == null) return;

      final weightValue = double.tryParse(_weightController.text);

      if (weightValue == null) {
        ScaffoldMessengerService.instance.displayError('add a valid weight');

        return;
      }

      if (_weighDate == null) {
        ScaffoldMessengerService.instance.displayError('add a valid date');

        return;
      }

      final weight =
          widget.weight?.copyWith(date: _weighDate!, weight: weightValue) ??
              Weight(
                id: 0,
                createdAt: null,
                updatedAt: null,
                deletedAt: null,
                date: _weighDate!,
                weight: weightValue,
                userId: user.id,
              );

      final result = await Provider.of<WeightProvider>(context, listen: false)
          .save(weight);

      if (result) {
        _weightController.clear();
        _dateController.clear();
        NavigationService.instance.pop();
      }
    } catch (ex) {
      ScaffoldMessengerService.instance.displayError('error upserting weight');
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
              height: 260,
              child: Provider.of<WeightProvider>(context, listen: false)
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
                        CustomTextField(
                          controller: _weightController,
                          label: 'weight',
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
                                  _weightController.clear();
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
                                  _addWeight(context);
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
                  'add weight',
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
