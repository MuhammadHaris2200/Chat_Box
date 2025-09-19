import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: mq.height * .05,),
          
          
          Row(
            children: [
              IconButton(onPressed: () {
                
              }, icon: Icon(Icons.search))
            ],
          )
        ],
      ),
    );
  }
}
