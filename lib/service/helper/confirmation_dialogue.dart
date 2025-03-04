import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogue extends StatelessWidget {
  final String title;
  final String content;
  final String item;
  const ConfirmationDialogue({
    Key? key,
    required this.title,
    required this.content,
    required this.item,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyles.white15Medium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                content,
                style: TextStyles.white15Medium,
              ),
            ),
            Text(
              item,
              style: TextStyles.white15Medium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      NavigationService.instance.pop(false);
                    },
                    child: const Text(
                      'cancel',
                      style: TextStyles.white15Medium,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomOutlinedButton(
                    onPressed: () {
                      NavigationService.instance.pop(true);
                    },
                    child: const Text(
                      'confirm',
                      style: TextStyles.white15Medium,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
