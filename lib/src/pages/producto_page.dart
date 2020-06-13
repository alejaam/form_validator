import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/src/models/producto_model.dart';
import 'package:form_validator/src/providers/productos_provider.dart';
import 'package:form_validator/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  File foto;

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
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
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
                  _mostrarFoto(),
                  Divider(),
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

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _guardando = true;

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosProvider.subirImagen(foto);
    }

    if (producto.id == null) {
      productosProvider.crearProducto(producto);
    } else {
      productosProvider.editarProducto(producto);
    }

    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _guardando = false;
      });
    });
    mostrarSnackbar('Registro guardado');
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      action: SnackBarAction(
          label: 'Volver', onPressed: () => Navigator.pop(context, 'home')),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  // _mostrarFoto() {
  //   if (producto.fotoUrl != null) {
  //     // TODO: tengo que hacer esto
  //     return Container();
  //   } else {
  //     return Image(
  //       image: AssetImage(foto?.path ?? 'assets/no-image.png'),
  //       height: 300.0,
  //       fit: BoxFit.cover,
  //     );
  //   }
  // }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
          image: NetworkImage(producto.fotoUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.cover);
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final imagen = await _picker.getImage(source: origen);

    if (imagen != null) {
      producto.fotoUrl = null;
    }

    setState(() {
      foto = File(imagen?.path ?? 'assets/no-image.png');
    });
  }
}
