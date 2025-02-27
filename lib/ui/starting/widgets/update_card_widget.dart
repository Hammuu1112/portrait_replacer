import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portrait_replacer/ui/starting/controller/starting_controller.dart';
import 'package:portrait_replacer/utils/external_links.dart';
import 'package:provider/provider.dart';

class UpdateCardWidget extends StatelessWidget {
  const UpdateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final updateAvailable = context.select<StartingController, bool>(
      (controller) => controller.updateAvailable,
    );
    if (!updateAvailable) {
      return Container();
    }
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.all(24.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.bell),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.tr("new version available"),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                SizedBox(width: 22),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => openUrl(ExternalLinks.latestRelease),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text(context.tr("detail")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
