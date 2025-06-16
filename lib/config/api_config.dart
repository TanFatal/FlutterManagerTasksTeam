class ApiConfig {
  // static const String baseUrl = 'https://vinachemshop.com:81/api';
  static const String baseUrl = 'http://10.0.2.2:8082/MyApp1/api';

  // static const String baseUrl = 'http://192.168.0.132:8092/ecommerce/api';
  // static const String baseUrl = 'http://192.168.0.226:99/api';
  // static const String baseUrl = 'http://erp.lixco.com:8180/ecommerce/api';
  // static const String socketUrl = 'http://192.168.0.248:3333';

  static const String securityKey = '';
  static const String clientSecret = '';
  static const String accessType = '';

  // static const String baseUrl = 'http://192.168.0.248:3333';
  // static const String baseUrl = 'http://vinachemshop.com';
  // static const String socketUrl = 'http://192.168.0.248:3333';
  // API configuration
  // Socket Events
  // static const String connect = 'connect';
  // static const String disconnect = 'disconnect';
  // static const String error = 'error';
  // static const String notification = 'notification';
  // static const String productUpdate = 'product_update';
  // static const String subscribeToProduct = 'product:subscribe';
  // static const String unsubscribeProduct = 'product:unsubscribe';

  // API Endpoints
  static const String users = '/users';
  static const String roomChat = '/users/roomchat';
  static const String task = '/users/task';
  static const String project = '/users/project';
  static const String notifica = '/users/notification';
  static const String lastMessage = '/users/message/lastMessage';
  static const String message = '/users/message';
  static const String channel = '/users/channel';
  static const String activityLog = '/users/activitylog';
  
  //auth
  static const String emailLogin = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String emailRegister = '/auth/register';
  static const String forgotPassWord = '/auth/forgot/password';
  // Method to get token from secure storage
  static Future<String?> getToken() async {
    // Implement token retrieval from secure storage
    // For example, using flutter_secure_storage
    // final storage = FlutterSecureStorage();
    // return await storage.read(key: 'authToken');
    return null;
  }
}
