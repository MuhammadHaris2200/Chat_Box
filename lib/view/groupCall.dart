import 'package:flutter/material.dart';

class Groupcall extends StatefulWidget {
  const Groupcall({super.key});

  @override
  State<Groupcall> createState() => _GroupcallState();
}

class _GroupcallState extends State<Groupcall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Call"),
        centerTitle: true,
      ),
    );
  }
}
