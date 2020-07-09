import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/pesquisa_produtos_modelos.dart';
import 'package:pretainformatica/telas/categorias_produtos_tela.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemCategoria extends StatefulWidget {
  final DocumentSnapshot doc;
  final String setor; //produtos_info ou produtos_cel

  const ItemCategoria({Key key, this.doc, this.setor}) : super(key: key);

  @override
  _ItemCategoriaState createState() => _ItemCategoriaState();
}

class _ItemCategoriaState extends State<ItemCategoria> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PesquisaModelo>(
      builder: (context, child, model) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                model.alterarSetor(widget.setor);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoriasProdutosTela(
                          doc: widget.doc,
                          titulo: widget.doc.data['titulo'],
                        )));
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              FadeInImage.assetNetwork(
                                placeholder:
                                    "assets/animacoes/loader_categorias.gif",
                                image: widget.doc.data['icone'],
                                imageScale: 14,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          widget.doc.data['titulo'],
                          style: fontLight16Dark,
                        ),
                      ],
                    ),
                    Icon(CupertinoIcons.right_chevron)
                  ],
                ),
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
