import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/data/models/portrait.dart';
import 'package:portrait_replacer/ui/portrait_replacer/controller/portrait_replacer_controller.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/portrait_card_widget.dart';
import 'package:portrait_replacer/utils/portrait_spec.dart';
import 'package:provider/provider.dart';

class PortraitGridViewWidget extends StatelessWidget {
  const PortraitGridViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PortraitReplacerController>(
      builder: (context, controller, child) {
        if (controller.portraits == null) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.portraits!.isEmpty) {
          return Center(child: Text(context.tr("empty")));
        }
        return Center(
          child: AnimatedReorderableGridView(
            padding: EdgeInsets.all(24.0),
            scrollDirection: Axis.vertical,
            items: controller.portraits!,
            itemBuilder: (context, index) {
              final item = controller.portraits![index];
              return _PortraitCard(
                key: ValueKey(item.path),
                portrait: item,
                selectImage: controller.pickImage,
                replaceImage:
                    (path) async =>
                        await controller.replacePortrait(path, index),
                onHide: () => controller.hideImage(index),
                onReset: () async => await controller.resetImage(index),
              );
            },
            sliverGridDelegate:
                SliverReorderableGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: PortraitSpec.horizontalCount,
                  childAspectRatio: PortraitSpec.width / PortraitSpec.height,
                  mainAxisSpacing: 6.0,
                  crossAxisSpacing: 6.0,
                ),
            enterTransition: [FadeIn(), ScaleIn()],
            exitTransition: [FadeIn()],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
            onReorder: controller.onReorder,
            onReorderEnd: (value) => controller.onReorderEnd(),
            dragStartDelay: Duration(milliseconds: controller.dragDelay),
            isSameItem: (a, b) => a.path == b.path,
          ),
        );
      },
    );
  }
}

class _PortraitCard extends StatefulWidget {
  final Portrait portrait;
  final Future<String?> Function() selectImage;
  final Future<void> Function(String) replaceImage;
  final void Function() onHide;
  final Future<void> Function() onReset;

  const _PortraitCard({
    super.key,
    required this.portrait,
    required this.selectImage,
    required this.replaceImage,
    required this.onHide,
    required this.onReset,
  });

  @override
  State<_PortraitCard> createState() => _PortraitCardState();
}

class _PortraitCardState extends State<_PortraitCard> {
  bool loading = false;

  Future<void> replace() async {
    final selected = await widget.selectImage();
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        loading = true;
      });
      await widget.replaceImage(selected);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> reset() async {
    setState(() {
      loading = true;
    });
    await widget.onReset();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: loading ? null : replace,
        child: PortraitCardWidget(
          portrait: widget.portrait,
          loading: loading,
          topPositioned: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: widget.onHide,
                icon: Icon(Icons.visibility_off),
              ),
              IconButton(
                onPressed: reset,
                icon: Icon(Icons.settings_backup_restore),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
