import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:portrait_replacer/data/models/version.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:portrait_replacer/utils/external_links.dart';

class VersionCheckService {
  Future<Version> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return Version.fromString(packageInfo.version);
  }

  Future<Version?> getLatestVersion() async {
    Version? result;
    try {
      final response = await http.get(Uri.parse(ExternalLinks.latestVersion));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String version = data["tag_name"];
        result = Version.fromString(version.replaceFirst("v", ""));
      }
    } catch (e) {
      developer.log("Failed to get latest version", error: e);
    }
    return result;
  }
}
