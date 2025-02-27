import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectLanguageWidget extends StatelessWidget {
  const SelectLanguageWidget({super.key});

  void setLocale(String? value, BuildContext context) {
    if (value != null) {
      context.setLocale(value.toLocale());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
          child: Text(
            "Language",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(height:545 ,child: _LocaleList())
        //Padding(padding: const EdgeInsets.all(8.0), child: _LocaleList()),
      ],
    );
  }
}

class _LocaleList extends StatelessWidget {
  const _LocaleList({super.key});

  void setLocale(String? value, BuildContext context) {
    if (value != null) {
      context.setLocale(value.toLocale());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        RadioListTile(
          value: "de_DE",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Deutsch"),
        ),
        RadioListTile(
          value: "en_US",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("English"),
        ),
        RadioListTile(
          value: "es_ES",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Español"),
        ),
        RadioListTile(
          value: "fr_FR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Français"),
        ),
        RadioListTile(
          value: "ja_JP",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("日本語"),
        ),
        RadioListTile(
          value: "ko_KR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("한국어"),
        ),
        RadioListTile(
          value: "pt_BR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Português (Brasil)"),
        ),
        RadioListTile(
          value: "ru_RU",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Русский"),
        ),
        RadioListTile(
          value: "tr_TR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Türkçe"),
        ),
        RadioListTile(
          value: "zh_CN",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("汉语 (简体)"),
        ),
        RadioListTile(
          value: "zh_TW",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("漢語 (繁體)"),
        ),
      ],
    );
    return Column(
      children: [
        RadioListTile(
          value: "de_DE",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Deutsch"),
        ),
        RadioListTile(
          value: "en_US",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("English"),
        ),
        RadioListTile(
          value: "es_ES",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Español"),
        ),
        RadioListTile(
          value: "fr_FR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Français"),
        ),
        RadioListTile(
          value: "ja_JP",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("日本語"),
        ),
        RadioListTile(
          value: "ko_KR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("한국어"),
        ),
        RadioListTile(
          value: "pt_BR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Português (Brasil)"),
        ),
        RadioListTile(
          value: "ru_RU",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Русский"),
        ),
        RadioListTile(
          value: "tr_TR",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("Türkçe"),
        ),
        RadioListTile(
          value: "zh_CN",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("汉语 (简体)"),
        ),
        RadioListTile(
          value: "zh_TW",
          groupValue: context.locale.toString(),
          onChanged: (value) => setLocale(value, context),
          title: Text("漢語 (繁體)"),
        ),
      ],
    );
  }
}
