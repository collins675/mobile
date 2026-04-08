import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/api_config.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/logincontroller.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/configs/routes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  Get.put(SessionController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RB App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: routes,
    );
  }
}

LoginController logincontroller = Get.put(LoginController());
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "RB",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Image.asset("assets/bike.png", width: 100),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
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
                      "Enter Name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person_2_outlined),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Obx(
                  () => TextField(
                    controller: confirmPasswordController,
                    obscureText: !logincontroller.passwordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Confirm PIN or Password",
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
                      "Sign up",
                      style: TextStyle(color: inverseTextColor, fontSize: 14),
                    ),
                  ),
                ),

                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);

                  if (emailController.text.isEmpty ||
                      nameController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  try {
                    final response = await post(
                      Uri.parse("${ApiConfig.baseUrl}/create.php"),
                      body: {
                        "Fullname": nameController.text,
                        "email": emailController.text,
                        "password": passwordController.text,
                      },
                    );

                    final data = jsonDecode(response.body);

                    if (data["status"] == "success") {
                      messenger.showSnackBar(
                        SnackBar(content: Text("Signup successful")),
                      );
                      Get.offAndToNamed("/login");
                    } else {
                      messenger.showSnackBar(
                        SnackBar(content: Text(data["message"])),
                      );
                    }
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text("Error: $e")),
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
                        "Login",
                        style: TextStyle(color: primaryColor, fontSize: 18),
                      ),
                      onTap: () {
                        Get.toNamed("/login");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
