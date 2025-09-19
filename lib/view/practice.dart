import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 👈 horizontal scroll
        child: Row(
          children: List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.teal,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage("assets/images/img.png"),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("User $index"),
                ],
              ),
            );
          }),
        ),
      )

    );
  }
}
