import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pretainformatica/datas/produtos_data.dart';

class CarrinhoProdutos {
  String cid;

  String setor;
  String categoria;
  String pid;
  int quantidade;
  Timestamp date;

  ProdutoData productData;

  CarrinhoProdutos();

  CarrinhoProdutos.fromDocument(DocumentSnapshot document) {
    setor = document.data['setor'];
    cid = document.documentID;
    categoria = document.data['categoria'];
    pid = document.data['pid'];
    quantidade = document.data['quantidade'];
    //date = document.data['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      "categoria": categoria.toLowerCase(),
      "setor": setor,
      "pid": pid,
      "quantidade": quantidade,
      //"date": date,
      "produto": productData.toResumeMap(),
    };
  }
}
