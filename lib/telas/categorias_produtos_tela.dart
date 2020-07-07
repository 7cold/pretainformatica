import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/modelos/pesquisa_produtos_modelos.dart';
import 'package:pretainformatica/widgets/categorias/item_categorias_produtos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoriasProdutosTela extends StatefulWidget {
  final DocumentSnapshot doc;
  final String titulo;

  CategoriasProdutosTela({@required this.doc, @required this.titulo});

  @override
  _CategoriasProdutosTelaState createState() =>
      _CategoriasProdutosTelaState(doc, titulo);
}

class _CategoriasProdutosTelaState extends State<CategoriasProdutosTela> {
  final DocumentSnapshot doc;
  final String titulo;

  _CategoriasProdutosTelaState(this.doc, this.titulo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(corPrincipal),
      appBar: appBar(context, titulo, false),
      body: SafeArea(
        child: ScopedModelDescendant<PesquisaModelo>(
          builder: (context, child, model) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 1.1,
                    child: FutureBuilder<QuerySnapshot>(
                      future: Firestore.instance
                          .collection(model.setor)
                          .document(doc.documentID)
                          .collection('itens')
                          .where("ativo", isEqualTo: true)
                          .getDocuments(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CupertinoActivityIndicator());
                        } else {
                          return snapshot.data.documents.length >= 1
                              ? ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      left: 25, right: 25, bottom: 30),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    ProdutoData data = ProdutoData.fromDocument(
                                        snapshot.data.documents[index]);
                                    return ItemCategoriaProdutos(
                                        data: data,
                                        categoria: doc.documentID,
                                        doc: doc);
                                  },
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Nenhum produto, volte para continuar",
                                        style: fontBold16Grey,
                                      ),
                                    ],
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
