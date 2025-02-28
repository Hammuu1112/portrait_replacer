import 'package:url_launcher/url_launcher.dart';

class ExternalLinks {
  static String discord = "https://discord.gg/8ZRAMGdcYG";
  static String github = "https://github.com/Hammuu1112/portrait_replacer";
  static String karanda = "https://karanda.kr";
  static String latestRelease =
      "https://github.com/Hammuu1112/portrait_replacer/releases/latest";
  static String latestVersion =
      "https://api.github.com/repos/hammuu1112/portrait_replacer/releases/latest";
}

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}
