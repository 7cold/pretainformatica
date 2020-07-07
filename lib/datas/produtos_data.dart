import 'package:cloud_firestore/cloud_firestore.dart';

class ProdutoData {
  String categoria;
  String setor;
  String id;

  String descricao;
  String imagem;
  String key;
  double kg;
  List listaImagens;
  String marca;
  double precoNormal;
  double precoPromocao;
  List tags;
  String titulo;
  int quantidadeE;

  ProdutoData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    descricao = snapshot.data['descricao'];
    setor = snapshot.data['setor'];
    imagem = snapshot.data['imagem'];
    key = snapshot.data['key'];
    kg = snapshot.data['kg'] + 0.0;
    listaImagens = snapshot.data['lista_imagens'];
    marca = snapshot.data['marca'];
    precoNormal = snapshot.data['preco_normal'] + 0.0;
    precoPromocao = snapshot.data['preco_promocao'] + 0.0;
    tags = snapshot.data['tags'];
    titulo = snapshot.data['titulo'];
    quantidadeE = snapshot.data['quantidade_e'];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "titulo": titulo,
      "descricao": descricao,
      "preco": precoPromocao,
      "marca": marca
    };
  }
}
