class ApiConfig {

  static const String baseUrl = 'http://10.0.2.2:8082/MyApp1/api';

  static const String securityKey = '';
  static const String clientSecret = '';
  static const String accessType = '';


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

    return null;
  }
}
