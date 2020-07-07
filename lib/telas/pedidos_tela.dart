import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/widgets/pedidos/item_pedidos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:scoped_model/scoped_model.dart';

class PedidosTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Pedidos", false),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          return model.usuarioData['nome'] == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SafeArea(
                  child: FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance
                        .collection("usuarios")
                        .document(model.firebaseUser.uid)
                        .collection("ordens")
                        .orderBy("data", descending: true)
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return ItemPedidosItens(
                                snapshot.data.documents[index].documentID);
                          },
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
