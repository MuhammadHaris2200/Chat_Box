import 'package:flutter/material.dart';

class Groupmessage extends StatefulWidget {
  const Groupmessage({super.key});

  @override
  State<Groupmessage> createState() => _GroupmessageState();
}

class _GroupmessageState extends State<Groupmessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Message"),
        centerTitle: true,
      ),
    );
  }
}
