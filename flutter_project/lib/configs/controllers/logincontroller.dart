import 'dart:convert';
import 'package:flutter_application_1/configs/api_config.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class LoginController extends GetxController {
  var passwordVisible = false.obs;
  final RxnString errorMessage = RxnString();
  final SessionController sessionController = Get.find<SessionController>();

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<bool> login(String email, String password) async {
    try {
      errorMessage.value = null;
      final response = await post(
        Uri.parse("${ApiConfig.baseUrl}/read.php"),
        headers: const {"Accept": "application/json"},
        body: {"email": email, "password": password},
      ).timeout(const Duration(seconds: 15));

      final rawBody = response.body.trim();
      if (rawBody.isEmpty) {
        errorMessage.value = "The server returned an empty response.";
        return false;
      }

      final data = jsonDecode(rawBody);
      if (data is! Map<String, dynamic>) {
        errorMessage.value = "Unexpected response from the login API.";
        return false;
      }

      if (data["status"] == "success") {
        final user = (data["user"] as Map).cast<String, dynamic>();
        sessionController.setUser({
          ...user,
          "id": int.tryParse('${user['id']}') ?? user['id'],
        });
        return true;
      } else {
        errorMessage.value =
            data["message"]?.toString() ?? "Invalid email or password";
        return false;
      }
    } catch (e) {
      errorMessage.value =
          "Could not connect to ${ApiConfig.baseUrl}. Check that Apache and MySQL are running.";
      return false;
    }
  }
}
