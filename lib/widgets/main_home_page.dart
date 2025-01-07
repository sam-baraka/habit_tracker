import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


@RoutePage()
class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome home"),
      ),
      body: Center(
        child: Text("Here is Home"),
      ),
    );
  }
}
