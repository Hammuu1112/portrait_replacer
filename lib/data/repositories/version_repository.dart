import 'package:portrait_replacer/data/models/version.dart';
import 'package:portrait_replacer/data/services/version_check_service.dart';

class VersionRepository {
  final VersionCheckService _service;
  Version? currentVersion;
  Version? latestVersion;

  VersionRepository({required VersionCheckService service})
    : _service = service;

  ///Returns `false` if [currentVersion] or [latestVersion] is `null`.
  bool get updateAvailable =>
      currentVersion == null || latestVersion == null
          ? false
          : !currentVersion!.isNewerThan(latestVersion!);

  Future<void> getVersions() async {
    currentVersion = await _service.getCurrentVersion();
    latestVersion = await _service.getLatestVersion();
  }
}
