import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/core/ui/loading_indicator_dialog.dart';
import 'package:portrait_replacer/ui/portrait_replacer/controller/portrait_replacer_controller.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/configuration_widget.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/hidden_image_group_widget.dart';
import 'package:provider/provider.dart';

class RailMenuWidget extends StatefulWidget {
  const RailMenuWidget({super.key});

  @override
  State<RailMenuWidget> createState() => _RailMenuWidgetState();
}

class _RailMenuWidgetState extends State<RailMenuWidget> {
  bool extended = false;

  Future<void> fillWithOne() async {
    final selected =
        await context.read<PortraitReplacerController>().pickImage();
    if (mounted && selected != null && selected.isNotEmpty) {
      showProcessingDialog(
        stream: context.read<PortraitReplacerController>().fillWithOne(
          selected,
        ),
      );
    }
  }

  void showHiddenImageGroup() {
    final controller = context.read<PortraitReplacerController>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return HiddenImageGroupWidget(
          portraits: controller.hiddenPortraits,
          showPortrait: controller.showImage,
        );
      },
    );
  }

  void showConfigMenu() {
    final controller = context.read<PortraitReplacerController>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ConfigurationWidget(controller: controller);
      },
    );
  }

  void showProcessingDialog({Stream<double>? stream}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingIndicatorDialog(valueStream: stream),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          extended = true;
        });
      },
      onExit: (_) {
        setState(() {
          extended = false;
        });
      },
      child: NavigationRail(
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.wallpaper),
            //icon: Icon(Icons.grid_on),
            label: Text(context.tr("fill")),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.settings_backup_restore),
            label: Text(context.tr("reset all portraits")),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.perm_media_outlined),
            label: Text(context.tr("hidden portraits")),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.tune),
            label: Text(context.tr("config")),
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              fillWithOne();
              break;
            case 1:
              showProcessingDialog(
                stream:
                    context.read<PortraitReplacerController>().resetAllImage(),
              );
              break;
            case 2:
              showHiddenImageGroup();
              break;
            case 3:
              showConfigMenu();
              break;
          }
        },
        selectedIndex: null,
        extended: extended,
        minExtendedWidth: 196,
        minWidth: 62,
      ),
    );
  }
}
