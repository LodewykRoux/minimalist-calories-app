import 'package:calories_app/models/weight.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/weight/weight_dialogue.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/helper/confirmation_dialogue.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightList extends StatelessWidget {
  const WeightList({super.key});

  Future<void> _onTileLongPress(BuildContext context, Weight weight) async {
    bool result = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialogue(
        title: 'Delete Weight',
        content: 'Are you sure you want to delete entry',
        item:
            '${DateService.toNormalDate(date: weight.date)} - ${weight.weight}',
      ),
    );

    if (result) {
      await Provider.of<WeightProvider>(context, listen: false).remove(weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await Provider.of<WeightProvider>(context, listen: false).getAll();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                NavigationService.instance.pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Consumer<WeightProvider>(
          builder: (context, value, child) {
            final weights = value.weights.toList()
              ..sort(
                (a, b) => a.date.compareTo(b.date),
              );

            return Column(
              children: [
                Expanded(
                  child: value.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: weights.length,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Colors.white,
                              endIndent: 20,
                              indent: 20,
                            );
                          },
                          itemBuilder: (context, index) {
                            final weight = weights[index];

                            return ListTile(
                              onLongPress: () {
                                _onTileLongPress(context, weight);
                              },
                              title: Text(
                                '${DateService.toNormalDate(date: weight.date)} - ${weight.weight}',
                              ),
                              trailing: WeightDialogue(
                                isButton: false,
                                weight: weight,
                              ),
                            );
                          },
                        ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeightDialogue(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
