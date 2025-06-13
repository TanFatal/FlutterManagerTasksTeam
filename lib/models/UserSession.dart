import 'package:testflutter/models/user.dart';

class UserSession {
  static User? currentUser;

  static void clear() {
    currentUser = null;
  }
}