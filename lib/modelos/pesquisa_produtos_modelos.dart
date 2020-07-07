import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/widgets/sistema/pesquisa.dart';
import 'package:scoped_model/scoped_model.dart';

class PesquisaModelo extends Model {
  var queryResultSet = [];
  var tempSearchStore = [];
  String categoria = "acessorios";
  String setor = "produtos_informatica";

  static PesquisaModelo of(BuildContext context) =>
      ScopedModel.of<PesquisaModelo>(context);

  void alterarSetor(String novoSetor) {
    setor = novoSetor;
    queryResultSet = [];
    tempSearchStore = [];
    notifyListeners();
    print(setor);
  }

  select(docID) {
    categoria = docID;
    print(categoria);
    notifyListeners();
  }

  initiateSearch(value) {
    if (value.length == 0) {
      queryResultSet = [];
      tempSearchStore = [];
      notifyListeners();
    }

    if (queryResultSet.length == 0 && value.length == 1) {
      // print("pesquisando");
      // print(value.length);
      SearchService()
          .searchByName(value.toUpperCase(), categoria, setor)
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i]);
          print(queryResultSet);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        tempSearchStore.add(element);
        // print("tempSearchStore");
        // print(tempSearchStore);
        notifyListeners();
      });
    }
  }
}
