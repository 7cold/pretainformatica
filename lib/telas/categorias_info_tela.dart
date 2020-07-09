import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/pesquisa_produtos_modelos.dart';
import 'package:pretainformatica/widgets/categorias/item_categoria.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriasInfoTela extends StatefulWidget {
  @override
  _CategoriasInfoTelaState createState() => _CategoriasInfoTelaState();
}

class _CategoriasInfoTelaState extends State<CategoriasInfoTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Informática", false),
      body: ScopedModelDescendant<PesquisaModelo>(
        builder: (context, child, model) {
          return Container(
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("produtos_informatica")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  return ListView(
                    padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: snapshot.data.documents.map((doc) {
                      return ItemCategoria(
                        doc: doc,
                        setor: "produtos_informatica",
                      );
                    }).toList(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
