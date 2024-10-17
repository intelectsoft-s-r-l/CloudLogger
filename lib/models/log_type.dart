enum LogType {
  critical(1),
  error(2),
  warning(4),
  information(8);

  final int code;

  const LogType(this.code);
}
