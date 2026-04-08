import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart';

class LoginController extends GetxController {
  var passwordVisible = false.obs;

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await post(
        Uri.parse("http://localhost/bicycles/read.php"), // for Chrome
        body: {"email": email, "password": password},
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }
}
