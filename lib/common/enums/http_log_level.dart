/// 日志级别枚举
enum HttpLogLevel {
  none(0),
  errors(1),
  headers(2),
  body(3);

  final int level;

  const HttpLogLevel(this.level);

  bool operator >=(HttpLogLevel other) => level >= other.level;
}
