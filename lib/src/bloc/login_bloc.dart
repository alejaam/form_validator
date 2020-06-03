import 'dart:async';

import 'package:form_validator/src/bloc/validator.dart';

class LoginBloc with Validators {
  //Haremos 2 controladores, uno para el email y otro para el password
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  //Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  // Stream<bool> get formValidStream => 
  //   CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

  //Insertar valores al Stream
  Function(String) get chageEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
