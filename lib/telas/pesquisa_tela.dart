import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/modelos/pesquisa_produtos_modelos.dart';
import 'package:pretainformatica/widgets/categorias/item_categorias_produtos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/campo_texto.dart';
import 'package:scoped_model/scoped_model.dart';

class PesquisaTela extends StatefulWidget {
  @override
  _PesquisaTelaState createState() => _PesquisaTelaState();
}

class _PesquisaTelaState extends State<PesquisaTela> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(corPrincipal),
        appBar: appBar(context, "Pesquisar", true),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ScopedModelDescendant<PesquisaModelo>(
            builder: (context, child, model) {
              return Column(children: <Widget>[
                //setores
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            model.alterarSetor("produtos_informatica");
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: model.setor == "produtos_informatica"
                                    ? Color(corAccent)
                                    : Color(corDark)),
                            child: Center(
                              child: Text(
                                "INFORMÁTICA",
                                style: fontBold14White,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            model.alterarSetor("produtos_celulares");
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: model.setor == "produtos_celulares"
                                    ? Color(corAccent)
                                    : Color(corDark)),
                            child: Center(
                              child: Text(
                                "CELULARES",
                                style: fontBold14White,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //tags
                FutureBuilder<QuerySnapshot>(
                  future:
                      Firestore.instance.collection(model.setor).getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      return Container(
                        height: 40,
                        child: ListView(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.documents.map((doc) {
                            return GestureDetector(
                              onTap: () {
                                model.select(doc.documentID);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                    color: Color(
                                        doc.documentID == model.categoria
                                            ? corAccent
                                            : corDark),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  child: Text(doc.documentID.toUpperCase(),
                                      style: fontBold14White),
                                )),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),

                //pesquisa
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Hero(
                    tag: "pesquisar",
                    child: Material(
                      child: CampoTexto(
                          textCapitalization: TextCapitalization.words,
                          readOnly: false,
                          controller: null,
                          hintText: "Pesquisar",
                          inputType: TextInputType.text,
                          passTrue: false,
                          onChanged: (val) {
                            print(val);
                            model.initiateSearch(val);
                          },
                          varValue: null),
                    ),
                  ),
                ),

                //resultado
                ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    primary: false,
                    shrinkWrap: true,
                    children: model.tempSearchStore.map((data) {
                      return buildResultCard(data, context, model.categoria);
                    }).toList())
              ]);
            },
          ),
        ));
  }
}

Widget buildResultCard(dataFire, context, categoria) {
  ProdutoData data = ProdutoData.fromDocument(dataFire);

  return ItemCategoriaProdutos(
    data: data,
    doc: dataFire,
    categoria: categoria,
  );
}
