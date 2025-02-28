class Version {
  final int major;
  final int minor;
  final int patch;
  final String text;

  Version({
    required this.major,
    required this.minor,
    required this.patch,
    required this.text,
  });

  factory Version.fromString(String value) {
    final v = value.split(".");
    return Version(
      major: int.parse(v.first),
      minor: int.parse(v[1]),
      patch: int.parse(v.last),
      text: value,
    );
  }

  /// Returns `true` if the version of **this** is `newer than` or `equal` to **other**
  bool isNewerThan(Version other) {
    if (major < other.major) {
      return false;
    } else if (minor < other.minor) {
      return false;
    } else if (patch < other.patch) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return text;
  }
}
