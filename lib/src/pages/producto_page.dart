import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_validator/src/models/producto_model.dart';
import 'package:form_validator/src/providers/productos_provider.dart';
import 'package:form_validator/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productosProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodArg = ModalRoute.of(context).settings.arguments;
    if (prodArg != null) {
      producto = prodArg;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _crearNombre(),
                  Divider(),
                  _crearPrecio(),
                  Divider(),
                  _crearDisponible(),
                  Divider(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length > 3) {
          return null;
        } else {
          return 'Introduce un nombre válido para el producto.';
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Precio', hintText: producto.valor.toString()),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
      label: Text('Guardar'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _guardando = true;

    setState(() {
      _guardando = true;
    });

    if (producto.id == null) {
      productosProvider.crearProducto(producto);
    } else {
      productosProvider.editarProducto(producto);
    }

    Timer(Duration(milliseconds: 1500), (){
      setState(() {
      _guardando = false;
    });
    });
    mostrarSnackbar('Registro guardado');
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
        content: Text(mensaje), duration: Duration(milliseconds: 1500),action: SnackBarAction(label: 'Volver', onPressed: () => Navigator.pop(context, 'home');),);

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
