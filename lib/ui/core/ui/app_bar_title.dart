import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
          text:"${context.tr("title")} ",
          style: TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: " Developed by Hammuu1112",
                style: Theme.of(context).textTheme.labelMedium
            )
          ]
      ),
    );
  }
}
