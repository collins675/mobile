import 'package:get/get.dart';

class SessionController extends GetxController {
  final Rxn<Map<String, dynamic>> currentUser = Rxn<Map<String, dynamic>>();

  int? get userId {
    final value = currentUser.value?['id'];
    if (value is int) {
      return value;
    }
    return int.tryParse('$value');
  }
  String get fullName => currentUser.value?['Fullname'] as String? ?? 'Rider';
  String get email => currentUser.value?['email'] as String? ?? '';

  void setUser(Map<String, dynamic> user) {
    currentUser.value = user;
  }

  void clear() {
    currentUser.value = null;
  }
}
