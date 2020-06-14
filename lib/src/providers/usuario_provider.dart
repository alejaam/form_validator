import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioProvider {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final String _firebaseToken = 'AIzaSyDLHuauR9ehqvosAhccZEfHj6JO9Qh_VYM';

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      // !important TODO: Salvar token en el storage
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'token': decodeResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final String _firebaseToken = 'AIzaSyDLHuauR9ehqvosAhccZEfHj6JO9Qh_VYM';

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);
    if (decodeResp.containsKey('idToken')) {
      // !important TODO: Salvar token en el storage
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'token': decodeResp['error']['message']};
    }
  }
}
