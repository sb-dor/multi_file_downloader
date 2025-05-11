enum DownloadMessageType {
  downloading._("downloading"),
  success._("success"),
  error._("error"),
  canceled._("canceled");
  // storageDenied._("storageDenied");

  final String value;
  const DownloadMessageType._(this.value);
}
