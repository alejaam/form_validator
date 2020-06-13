import 'package:flutter/material.dart';

import 'package:form_validator/src/bloc/provider.dart';

import 'package:form_validator/src/pages/home_page.dart';
import 'package:form_validator/src/pages/login.dart';
import 'package:form_validator/src/pages/producto_page.dart';
import 'package:form_validator/src/pages/registro_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
