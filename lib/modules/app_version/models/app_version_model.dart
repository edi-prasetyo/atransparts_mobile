class AppVersionRequest {
  final String platform;
  final String type;
  final String version;
  final String code;

  AppVersionRequest({
    required this.platform,
    required this.type,
    required this.version,
    required this.code,
  });

  Map<String, dynamic> toParams() => {
    'platform': platform,
    'type': type,
    'version': version,
    'code': code,
  };
}

class AppVersionResponse {
  final bool success;
  final AppVersionData? data;

  AppVersionResponse({required this.success, this.data});

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) {
    return AppVersionResponse(
      success: json['success'] == true,
      data: json['data'] != null
          ? AppVersionData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }
}

class AppVersionData {
  final bool updateAvailable;
  final bool forceUpdate;
  final String version;
  final String code;
  final String name;
  final String description;
  final String url;
  final String platform;
  final String type;

  AppVersionData({
    required this.updateAvailable,
    required this.forceUpdate,
    required this.version,
    required this.code,
    required this.name,
    required this.description,
    required this.url,
    required this.platform,
    required this.type,
  });

  factory AppVersionData.fromJson(Map<String, dynamic> json) {
    return AppVersionData(
      updateAvailable: _toBool(json['update_available']),
      forceUpdate: _toBool(json['force_update']),
      version: (json['version'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      platform: (json['platform'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
    );
  }
}

bool _toBool(dynamic v) => v == true || v == 1 || v == '1';
