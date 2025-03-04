import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class UnitOfMeasureDropdownButton extends DropdownMenu<UnitOfMeasureEnum> {
  UnitOfMeasureDropdownButton({
    super.key,
    required void Function(UnitOfMeasureEnum?)? onSelected,
    required UnitOfMeasureEnum value,
    required BuildContext context,
  }) : super(
          width: MediaQuery.sizeOf(context).width * 0.72,
          label: const Text(
            'Unit of measurement',
            style: TextStyles.white15Medium,
          ),
          dropdownMenuEntries: UnitOfMeasureEnum.values
              .map(
                (e) => DropdownMenuEntry<UnitOfMeasureEnum>(
                  value: e,
                  label: e.name,
                ),
              )
              .toList(),
          menuStyle: const MenuStyle(
            side: MaterialStatePropertyAll(BorderSide(color: Colors.white)),
          ),
          onSelected: onSelected,
          initialSelection: value,
        );
}
