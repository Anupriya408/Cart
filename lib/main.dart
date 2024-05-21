import 'package:flutter/material.dart';
import 'package:first_project/screens/product_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:first_project/models/cart.dart';
import 'package:first_project/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        title: 'Makeup App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          // accentColor: Colors.purple,
        ),
        home: LoginScreen(),
      ),
    );
  }
}



