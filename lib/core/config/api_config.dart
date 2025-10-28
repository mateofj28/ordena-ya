import 'dart:io';

class ApiConfig {
  // Configuración de la API
  static const String _localhost = 'localhost';
  static const String _androidEmulatorHost = '10.0.2.2';
  static const String _port = '3000';
  
  // Para desarrollo, puedes cambiar esta IP por la IP de tu máquina
  // Ejemplo: '192.168.1.100' si tu máquina tiene esa IP en la red local
  static const String _customHost = '192.168.1.20'; // IP de tu máquina
  
  static String get baseUrl {
    String host;
    
    if (_customHost.isNotEmpty) {
      // Si hay una IP personalizada, úsala
      host = _customHost;
    } else if (Platform.isAndroid) {
      // Android emulator usa 10.0.2.2 para acceder al host
      host = _androidEmulatorHost;
    } else {
      // iOS simulator y desktop usan localhost
      host = _localhost;
    }
    
    return 'http://$host:$_port/api';
  }
  
  static String get ordersEndpoint => '$baseUrl/orders';
  
  // Método para obtener información de configuración
  static Map<String, String> get info => {
    'platform': Platform.operatingSystem,
    'baseUrl': baseUrl,
    'ordersEndpoint': ordersEndpoint,
  };
}