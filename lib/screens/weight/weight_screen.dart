import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/weight/weight_dialogue.dart';
import 'package:calories_app/screens/weight/weight_list.dart';
import 'package:calories_app/service/date_service.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/date_dialog/date_dialog.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimeSeriesWeights {
  final DateTime time;
  final String weight;

  TimeSeriesWeights(this.time, this.weight);
}

final _monthDayFormat = DateFormat('yyyy-MM-dd');

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 365));
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fromDateController.text = DateService.toNormalDate(date: _fromDate);
    _toDateController.text = DateService.toNormalDate(date: _toDate);
  }

  Future<void> _updateFromDate(BuildContext context) async {
    final date = await dateDialogBuilder(context, _fromDate);

    if (date == null) return;

    setState(() {
      _fromDate = date;
      _fromDateController.text = DateService.toNormalDate(date: date);
    });
  }

  Future<void> _updateToDate(BuildContext context) async {
    final date = await dateDialogBuilder(context, _toDate);

    if (date == null) return;

    setState(() {
      _toDate = date;
      _toDateController.text = DateService.toNormalDate(date: date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      onRefresh: () async {
        await Provider.of<WeightProvider>(context, listen: false).getAll();
      },
      child: Consumer<WeightProvider>(
        builder: (context, value, child) {
          final weights = value.weights
              .toList()
              .where(
                (w) =>
                    w.date
                        .isAfter(_fromDate.subtract(const Duration(days: 1))) &&
                    w.date.isBefore(
                      _toDate.add(const Duration(days: 1)),
                    ),
              )
              .toList()
            ..sort(
              (a, b) => a.date.compareTo(b.date),
            );

          final timeSeries = weights
              .map(
                (e) => TimeSeriesWeights(e.date, e.weight.toStringAsFixed(1)),
              )
              .toList();

          return Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          _updateFromDate(context);
                        },
                        child: CustomTextField(
                          enabled: false,
                          controller: _fromDateController,
                          label: 'from date',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          _updateToDate(context);
                        },
                        child: CustomTextField(
                          enabled: false,
                          controller: _toDateController,
                          label: 'to date',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Expanded(
                child: value.weights.isEmpty
                    ? const Center(child: Text('no entries captured'))
                    : timeSeries.isEmpty
                        ? Center(
                            child: CustomOutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _fromDate = DateTime.now()
                                      .subtract(const Duration(days: 365));
                                  _toDate = DateTime.now();

                                  _fromDateController.text =
                                      DateService.toNormalDate(date: _fromDate);
                                  _toDateController.text =
                                      DateService.toNormalDate(date: _toDate);
                                });
                              },
                              child: const Text(
                                'reset',
                                style: TextStyles.white15Medium,
                              ),
                            ),
                          )
                        : timeSeries.length < 2
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Date: ${DateService.toNormalDate(date: timeSeries.firstOrNull?.time)}',
                                  ),
                                  Text(
                                    'Weight: ${timeSeries.firstOrNull?.weight}',
                                  ),
                                ],
                              )
                            : Chart(
                                rebuild: true,
                                data: timeSeries,
                                variables: {
                                  'time': Variable(
                                    accessor: (TimeSeriesWeights datum) =>
                                        datum.time,
                                    scale: TimeScale(
                                      formatter: (time) =>
                                          _monthDayFormat.format(time),
                                    ),
                                  ),
                                  'weight': Variable(
                                    accessor: (TimeSeriesWeights date) =>
                                        date.weight,
                                  ),
                                },
                                marks: [
                                  LineMark(
                                    color: ColorEncode(value: Colors.white),
                                  ),
                                ],
                                axes: [
                                  Defaults.horizontalAxis,
                                  Defaults.verticalAxis,
                                ],
                                selections: {
                                  'tap': PointSelection(
                                    on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate,
                                    },
                                    dim: Dim.x,
                                  ),
                                },
                                tooltip: TooltipGuide(
                                  followPointer: [false, true],
                                  align: Alignment.topLeft,
                                  offset: const Offset(-20, -20),
                                ),
                                crosshair: CrosshairGuide(),
                              ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomOutlinedButton(
                      onPressed: () {
                        NavigationService.instance.push(const WeightList());
                      },
                      child: const Row(
                        children: [
                          Text(
                            'edit data',
                            style: TextStyles.white15Medium,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const WeightDialogue(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
