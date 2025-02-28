import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/data/models/portrait.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/portrait_card_widget.dart';
import 'package:portrait_replacer/utils/portrait_spec.dart';

class HiddenImageGroupWidget extends StatelessWidget {
  final List<Portrait> portraits;
  final void Function(int) showPortrait;

  const HiddenImageGroupWidget({
    super.key,
    required this.portraits,
    required this.showPortrait,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              context.tr("hidden portraits"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child:
                portraits.isNotEmpty
                    ? _HorizontalPortraitList(
                      portraits: portraits,
                      showPortrait: showPortrait,
                    )
                    : Center(child: Text(context.tr("empty"))),
          ),
        ],
      ),
    );
  }
}

class _HorizontalPortraitList extends StatefulWidget {
  final List<Portrait> portraits;
  final void Function(int) showPortrait;

  const _HorizontalPortraitList({
    super.key,
    required this.portraits,
    required this.showPortrait,
  });

  @override
  State<_HorizontalPortraitList> createState() =>
      _HorizontalPortraitListState();
}

class _HorizontalPortraitListState extends State<_HorizontalPortraitList> {
  late final List<Portrait> portraits;

  @override
  void initState() {
    portraits = widget.portraits;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      child: ListView.builder(
        primary: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
        itemCount: portraits.length,
        itemBuilder: (context, index) {
          return _PortraitCard(
            portrait: portraits[index],
            onTap: () {
              setState(() {
                widget.showPortrait(index);
              });
            },
          );
        },
      ),
    );
  }
}

class _PortraitCard extends StatelessWidget {
  final Portrait portrait;
  final void Function() onTap;

  const _PortraitCard({super.key, required this.portrait, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AspectRatio(
        aspectRatio: PortraitSpec.width / PortraitSpec.height,
        child: PortraitCardWidget(
          portrait: portrait,
          topPositioned: Align(
            alignment: Alignment.topRight,
            child: IconButton(onPressed: onTap, icon: Icon(Icons.visibility)),
          ),
        ),
      ),
    );
  }
}
