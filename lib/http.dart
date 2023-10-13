import 'package:flutter/material.dart';
import 'package:the_movie/HttpHelper.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late String result;
  late HttpHelper helper;

@override
void initState() {
  super.initState();
  helper = HttpHelper();
  result = "";
}

  @override
  Widget build(BuildContext context) {
    helper.getMovie().then((value) {
      setState(() {
        result = value;
      });
    });
    return Scaffold(
      appBar: AppBar(title: Text("My Video")),
      body: SingleChildScrollView(
        child: Text("$result"),
      ),
    );
  }
}