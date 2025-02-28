import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/starting/controller/starting_controller.dart';
import 'package:provider/provider.dart';

class SelectPathWidget extends StatelessWidget {
  const SelectPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr("directory path"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: _TextFormField()),
        ],
      ),
    );
  }
}

class _TextFormField extends StatelessWidget {
  const _TextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.watch<StartingController>().textEditingController,
      decoration: InputDecoration(
        hintText: r"ex) C:\Users\{User}\Documents\Black Desert\FaceTexture",
        suffixIcon: IconButton(
          onPressed: context.read<StartingController>().selectPath,
          icon: Icon(Icons.folder_open),
        ),
      ),
      onChanged: context.read<StartingController>().textChanged,
    );
  }
}
