import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/logincontroller.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

LoginController logincontroller = Get.put(LoginController());
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.deepOrangeAccent,
      //   title: Text("Logging Page", style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "RB",
              style: TextStyle(
                color: primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            Image.asset("assets/bike.png", width: 200),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Enter Username",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hint: Text("Email or Phone Number"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Enter Password",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Obx(
                () => TextField(
                  controller: passwordController,
                  obscureText: !logincontroller.passwordVisible.value,
                  decoration: InputDecoration(
                    hintText: "PIN or Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        logincontroller.passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: logincontroller.togglePassword,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: inverseTextColor, fontSize: 14),
                  ),
                ),
              ),
              onTap: () async {
                if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  Get.snackbar("Error", "All fields are required");
                  return;
                }

                bool success = await logincontroller.login(
                  emailController.text,
                  passwordController.text,
                );

                if (success) {
                  Get.offAndToNamed("/homescreen");
                } else {
                  Get.snackbar(
                    "Login Failed",
                    logincontroller.errorMessage.value ??
                        "Invalid email or password",
                    backgroundColor: dangerSurfaceColor,
                    colorText: dangerColor,
                  );
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 30.0, 0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                    onTap: () {
                      Get.toNamed("/signup");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
