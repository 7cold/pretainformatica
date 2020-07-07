import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/telas/carrinho_tela.dart';
import 'package:pretainformatica/telas/usuario_tela.dart';

appBar(BuildContext context, String label, bool acoes) {
  return AppBar(
    actions: acoes == true
        ? <Widget>[
            IconButton(
                icon: Icon(FontAwesomeIcons.user),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UsuarioTela()));
                }),
            IconButton(
                icon: Icon(FontAwesomeIcons.shoppingBasket),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CarrinhoTela()));
                }),
          ]
        : null,
    backgroundColor: Color(corDark),
    title: Text(label, style: fontHeavy20White),
    centerTitle: false,
  );
}
