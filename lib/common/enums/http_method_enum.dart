

/// HTTP 方法枚举
enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  final String value;

  const HttpMethod(this.value);
}