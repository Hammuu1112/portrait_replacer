import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/starting/controller/starting_controller.dart';
import 'package:provider/provider.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Text(
        context.select<StartingController, String>(
          (controller) => controller.version,
        ),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
