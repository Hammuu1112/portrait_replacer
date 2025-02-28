import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portrait_replacer/ui/portrait_replacer/controller/portrait_replacer_controller.dart';

class ConfigurationWidget extends StatelessWidget {
  final PortraitReplacerController controller;

  const ConfigurationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                context.tr("config"),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _Tile(
              title: "image width",
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 20.0,
                ),
                child: TextFormField(
                  initialValue: controller.width.toString(),
                  maxLines: 1,
                  maxLength: 9,
                  decoration: InputDecoration(
                    suffixText: "px",
                    hintText: "624",
                    helperText: context.tr("image width hint text"),
                    counter: const SizedBox(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: controller.updateWidth,
                ),
              ),
            ),
            _Tile(
              title: "drag delay",
              child: _Slider(
                value: controller.dragDelay.toDouble(),
                min: 100,
                max: 300,
                divisions: 20,
                onChanged: controller.updateDragDelay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final Widget child;

  const _Tile({super.key, required this.title, required this.child});

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
            context.tr(title),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        child,
      ],
    );
  }
}

class _Slider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Future<void> Function(double) onChanged;

  const _Slider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
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
    return Slider(
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
    );
  }
}
