import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField, String categoria, String setor) {
    return Firestore.instance
        .collection(setor)
        .document(categoria)
        .collection('itens')
        .where('ativo', isEqualTo: true)
        .where('key', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }
}
