enum StateOfDownload { downloaded, downloading, error }

class DownloadFileEntity {
  final String? id;
  final String name;
  final DateTime date;
  final String path;

  DownloadFileEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.path,
  });

  static double convertBiteToMB(int bites) {
    return (bites / (1024 * 1024) * 1000).round() / 1000;
  }
}
