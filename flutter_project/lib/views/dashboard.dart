import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color.fromARGB(255, 4, 130, 130),
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text(
                "Welcome collins!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 8, 139, 159),
                    elevation: 10,
                    // shadowColor: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/display2.png"),
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(255, 14, 174, 163),
                    elevation: 10,
                    // shadowColor: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/display1.png"),
                    ),
                  ),
                  Card(
                    color: const Color.fromARGB(255, 17, 145, 142),
                    elevation: 10,
                    // shadowColor: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/display2.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
