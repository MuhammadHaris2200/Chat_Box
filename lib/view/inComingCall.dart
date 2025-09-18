import 'package:flutter/material.dart';

class Incomingcall extends StatefulWidget {
  const Incomingcall({super.key});

  @override
  State<Incomingcall> createState() => _IncomingcallState();
}

class _IncomingcallState extends State<Incomingcall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incoming Call"),
        centerTitle: true,
      ),
    );
  }
}
