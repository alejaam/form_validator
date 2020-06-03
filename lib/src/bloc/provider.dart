import 'package:flutter/material.dart';
import 'package:form_validator/src/bloc/login_bloc.dart';
export 'package:form_validator/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{
  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  Provider({Key key, Widget child})
    :super(key: key, child: child);

  //Cuando usemos este provider ocupamos la instancia del login bloc, que regrese el estado como esta este loginBloc
  static LoginBloc of (BuildContext context){
    return(context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc);
  }
}