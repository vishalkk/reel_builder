class MyReelItem {
  final String id;
  final String templateId;
  final String templateName;
  final String videoPath;
  final DateTime createdAt;
  final Map<String, String> textOverrides;
  final Map<String, String> themeOverrides;

  const MyReelItem({
    required this.id,
    required this.templateId,
    required this.templateName,
    required this.videoPath,
    required this.createdAt,
    required this.textOverrides,
    required this.themeOverrides,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'templateName': templateName,
      'videoPath': videoPath,
      'createdAt': createdAt.toIso8601String(),
      'textOverrides': textOverrides,
      'themeOverrides': themeOverrides,
    };
  }

  factory MyReelItem.fromJson(Map<String, dynamic> json) {
    return MyReelItem(
      id: json['id'] as String,
      templateId: json['templateId'] as String? ?? '',
      templateName: json['templateName'] as String? ?? 'Template',
      videoPath: json['videoPath'] as String,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      textOverrides:
          Map<String, String>.from(json['textOverrides'] as Map? ?? const {}),
      themeOverrides:
          Map<String, String>.from(json['themeOverrides'] as Map? ?? const {}),
    );
  }
}
