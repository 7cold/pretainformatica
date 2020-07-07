import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/login_tela.dart';
import 'package:pretainformatica/telas/principal_tela.dart';

import 'package:scoped_model/scoped_model.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  showAlertDialog1(BuildContext context) {
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog();
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((_) {
      UsuarioModelo.of(context).verifLogado() == true
          ? Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => PrincipalTela()))
          : Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginTela()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(corDark),
      body: ScopedModelDescendant<UsuarioModelo>(
          builder: (context, child, model) {
        return Center(
          child: Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      CupertinoThemeData(brightness: Brightness.dark)),
              child: CupertinoActivityIndicator()),
        );
      }),
    );
  }
}
