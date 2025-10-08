class ApiEndpoints {
  static const String _baseUrl = 'https://url-shortener-server.onrender.com';

  /// Cria um novo alias (encurta uma URL)
  static const String aliasCreate = '/api/alias';

  /// Obtém os detalhes de um alias existente
  static String aliasDetails(String aliasId) => '/api/alias/$aliasId';

  /// Retorna o endpoint completo (base + path)
  static String full(String path) => '$_baseUrl$path';
}
