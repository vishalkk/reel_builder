enum RenderSubmissionStatus {
  queued,
  processing,
  completed,
  failed,
  cancelled,
}

RenderSubmissionStatus renderSubmissionStatusFromString(String value) {
  switch (value) {
    case 'queued':
      return RenderSubmissionStatus.queued;
    case 'processing':
      return RenderSubmissionStatus.processing;
    case 'completed':
      return RenderSubmissionStatus.completed;
    case 'failed':
      return RenderSubmissionStatus.failed;
    case 'cancelled':
      return RenderSubmissionStatus.cancelled;
    default:
      return RenderSubmissionStatus.queued;
  }
}

String renderSubmissionStatusToString(RenderSubmissionStatus status) {
  switch (status) {
    case RenderSubmissionStatus.queued:
      return 'queued';
    case RenderSubmissionStatus.processing:
      return 'processing';
    case RenderSubmissionStatus.completed:
      return 'completed';
    case RenderSubmissionStatus.failed:
      return 'failed';
    case RenderSubmissionStatus.cancelled:
      return 'cancelled';
  }
}

class RenderSubmissionCreateRequest {
  final String templateId;
  final String idempotencyKey;
  final RenderSubmissionInputs inputs;
  final RenderOutputOptions output;

  const RenderSubmissionCreateRequest({
    required this.templateId,
    required this.idempotencyKey,
    required this.inputs,
    required this.output,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'template_id': templateId,
      'idempotency_key': idempotencyKey,
      'inputs': inputs.toJson(),
      'output': output.toJson(),
    };
  }
}

class RenderSubmissionInputs {
  final List<RenderSlotMediaInput> slotMedia;
  final Map<String, String> textValues;
  final Map<String, String> themeOverrides;

  const RenderSubmissionInputs({
    required this.slotMedia,
    this.textValues = const <String, String>{},
    this.themeOverrides = const <String, String>{},
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'slot_media':
          slotMedia.map((item) => item.toJson()).toList(growable: false),
      'text_values': textValues,
      'theme_overrides': themeOverrides,
    };
  }
}

class RenderSlotMediaInput {
  final String slotId;
  final String sourceFileId;
  final RenderTrimRange? trim;

  const RenderSlotMediaInput({
    required this.slotId,
    required this.sourceFileId,
    this.trim,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'slot_id': slotId,
      'source_file_id': sourceFileId,
      if (trim != null) 'trim': trim!.toJson(),
    };
  }
}

class RenderTrimRange {
  final double start;
  final double end;

  const RenderTrimRange({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'start': start,
      'end': end,
    };
  }
}

class RenderOutputOptions {
  final String format;
  final String resolution;
  final int fps;

  const RenderOutputOptions({
    this.format = 'mp4',
    this.resolution = '1080x1920',
    this.fps = 30,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'format': format,
      'resolution': resolution,
      'fps': fps,
    };
  }
}

class RenderSubmissionAcceptedResponse {
  final String submissionId;
  final String templateId;
  final RenderSubmissionStatus status;
  final int progress;
  final int? etaSeconds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RenderSubmissionAcceptedResponse({
    required this.submissionId,
    required this.templateId,
    required this.status,
    required this.progress,
    required this.etaSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RenderSubmissionAcceptedResponse.fromJson(Map<String, dynamic> json) {
    return RenderSubmissionAcceptedResponse(
      submissionId: (json['submission_id'] ?? '') as String,
      templateId: (json['template_id'] ?? '') as String,
      status: renderSubmissionStatusFromString(
          (json['status'] ?? 'queued') as String),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      etaSeconds: (json['eta_seconds'] as num?)?.toInt(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
      updatedAt: DateTime.tryParse((json['updated_at'] ?? '').toString()),
    );
  }
}

class RenderSubmissionStatusResponse {
  final String submissionId;
  final String templateId;
  final RenderSubmissionStatus status;
  final int progress;
  final int? etaSeconds;
  final RenderResult? result;
  final RenderError? error;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RenderSubmissionStatusResponse({
    required this.submissionId,
    required this.templateId,
    required this.status,
    required this.progress,
    required this.etaSeconds,
    this.result,
    this.error,
    this.createdAt,
    this.updatedAt,
  });

  factory RenderSubmissionStatusResponse.fromJson(Map<String, dynamic> json) {
    final resultJson = json['result'];
    final errorJson = json['error'];

    return RenderSubmissionStatusResponse(
      submissionId: (json['submission_id'] ?? '') as String,
      templateId: (json['template_id'] ?? '') as String,
      status: renderSubmissionStatusFromString(
          (json['status'] ?? 'queued') as String),
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      etaSeconds: (json['eta_seconds'] as num?)?.toInt(),
      result: resultJson is Map<String, dynamic>
          ? RenderResult.fromJson(resultJson)
          : null,
      error: errorJson is Map<String, dynamic>
          ? RenderError.fromJson(errorJson)
          : null,
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
      updatedAt: DateTime.tryParse((json['updated_at'] ?? '').toString()),
    );
  }
}

class RenderResult {
  final String fileId;
  final String downloadUrl;
  final DateTime? expiresAt;
  final double? duration;
  final String? resolution;
  final String? format;

  const RenderResult({
    required this.fileId,
    required this.downloadUrl,
    required this.expiresAt,
    required this.duration,
    required this.resolution,
    required this.format,
  });

  factory RenderResult.fromJson(Map<String, dynamic> json) {
    return RenderResult(
      fileId: (json['file_id'] ?? '') as String,
      downloadUrl: (json['download_url'] ?? '') as String,
      expiresAt: DateTime.tryParse((json['expires_at'] ?? '').toString()),
      duration: (json['duration'] as num?)?.toDouble(),
      resolution: json['resolution'] as String?,
      format: json['format'] as String?,
    );
  }
}

class RenderError {
  final String code;
  final String message;
  final bool retryable;

  const RenderError({
    required this.code,
    required this.message,
    required this.retryable,
  });

  factory RenderError.fromJson(Map<String, dynamic> json) {
    return RenderError(
      code: (json['code'] ?? '') as String,
      message: (json['message'] ?? '') as String,
      retryable: json['retryable'] == true,
    );
  }
}
