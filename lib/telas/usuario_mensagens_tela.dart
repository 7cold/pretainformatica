import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';

class UsuarioMensagensTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(corPrincipal),
      appBar: appBar(context, "Mensagens", false),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          return model.usuarioData['nome'] == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('usuarios')
                        .document(model.firebaseUser.uid)
                        .collection('mensagens')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Center(
                            child: CupertinoActivityIndicator(),
                          );
                        default:
                          return new Column(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 20, 10, 20),
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(2),
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: Color(corDark).withAlpha(50),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              document.data['titulo'],
                                              style: fontBold16Dark,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              document.data['descricao'],
                                              style: fontLight16Dark,
                                            ),
                                            SizedBox(height: 20),
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Color(corAccent)),
                                                  child: Text(
                                                    '${formatDate(document.data['data'].toDate(), [
                                                      dd,
                                                      '/',
                                                      mm,
                                                      '/',
                                                      yyyy,
                                                    ])}',
                                                    style: fontBold14White,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList()
                                .reversed
                                .toList(),
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
