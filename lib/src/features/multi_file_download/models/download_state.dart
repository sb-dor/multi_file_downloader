import 'package:flutter_multi_file_downloader/src/features/multi_file_download/enums/download_message_type.dart';

class DownloadState {
  final double progress;
  final DownloadMessageType message;
  final Object? error;

  const DownloadState({required this.progress, required this.message, this.error});

  bool get isComplete => message == DownloadMessageType.success;

  bool get isError => message == DownloadMessageType.error;

  DownloadState copyWith({double? progress, DownloadMessageType? message, Object? error}) {
    return DownloadState(
      progress: progress ?? this.progress,
      message: message ?? this.message,
      error: error,
    );
  }
}
