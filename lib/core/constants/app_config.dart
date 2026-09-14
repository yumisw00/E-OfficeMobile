class AppConfig {
  // Backend API Base URL - Ganti dengan IP/Domain server Laravel Anda
  static const String baseUrl = 'http://192.168.0.40:8000/api';
  
  // Timeout Configuration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Secure Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String activeGroupKey = 'active_group';
  
  // Debug & Logging
  static const bool enableLogging = true;
  
  // Feature Flags
  static const bool enableMockData = false; 
  
  // Constructor private untuk mencegah instantiasi
  AppConfig._();
}
