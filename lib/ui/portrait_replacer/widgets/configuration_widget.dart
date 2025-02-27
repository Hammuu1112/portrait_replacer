import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/portrait_replacer/controller/portrait_replacer_controller.dart';

class ConfigurationWidget extends StatelessWidget {
  final PortraitReplacerController controller;

  const ConfigurationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Text(
              context.tr("config"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _Slider(
            value: controller.width.toDouble(),
            min: 1,
            max: 13,
            divisions: 12,
            title: "width",
            onChanged: controller.updateWidth,
          ),
          _Slider(
            value: controller.dragDelay.toDouble(),
            min: 100,
            max: 300,
            divisions: 20,
            title: "drag delay",
            onChanged: controller.updateDragDelay,
          ),
        ],
      ),
    );
  }
}


class _Slider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String title;
  final Future<void> Function(double) onChanged;

  const _Slider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.title,
    required this.onChanged,
  });

  @override
  State<_Slider> createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  late double value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            context.tr(widget.title),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Slider(
          min: widget.min,
          max: widget.max,
          value: value,
          divisions: widget.divisions,
          label: value.toInt().toString(),
          onChanged: (changed) {
            setState(() {
              value = changed;
            });
            widget.onChanged(changed);
          },
        ),
      ],
    );
  }
}
