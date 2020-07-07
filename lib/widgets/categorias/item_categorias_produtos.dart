import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/carrinho_data.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/telas/carrinho_tela.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/telas/produtos_detalhes.dart';
import 'package:pretainformatica/widgets/sistema/nav_transition.dart';

class ItemCategoriaProdutos extends StatefulWidget {
  final ProdutoData data;
  final String categoria;
  final DocumentSnapshot doc;

  const ItemCategoriaProdutos({Key key, this.data, this.categoria, this.doc})
      : super(key: key);
  @override
  _ItemCategoriaProdutosState createState() =>
      _ItemCategoriaProdutosState(data, categoria, doc);
}

class _ItemCategoriaProdutosState extends State<ItemCategoriaProdutos> {
  final ProdutoData data;
  final String categoria;
  final DocumentSnapshot doc;

  _ItemCategoriaProdutosState(this.data, this.categoria, this.doc);

  bool animeAddCarrinho = false;

  @override
  Widget build(BuildContext context) {
    var precoNormal = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
    precoNormal.updateValue(data.precoNormal);

    var precoPromocao = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
    precoPromocao.updateValue(data.precoPromocao);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: data.quantidadeE == 0
            ? null
            : () {
                Navigator.push(
                    context,
                    FadeRoute(
                        page: ProdutosDetalhes(
                            data, categoria, data.quantidadeE)));
              },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 8,
          shadowColor: Color(corCinza).withAlpha(60),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Hero(
                      tag: data.imagem,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Stack(
                            children: [
                              Center(child: CupertinoActivityIndicator()),
                              Center(
                                child: Image.network(
                                  data.imagem,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 25,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.05,
                    child: Text(
                      data.titulo.length < 30
                          ? data.titulo + " | " + data.marca
                          : data.titulo.substring(0, 30) +
                              "..." +
                              " | " +
                              data.marca,
                      style: fontBold16Dark,
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: data.quantidadeE == 0
                            ? null
                            : () {
                                CarrinhoProdutos cartProduct =
                                    CarrinhoProdutos();
                                cartProduct.quantidade = 1;
                                cartProduct.pid = data.id;
                                cartProduct.categoria = categoria.toLowerCase();
                                cartProduct.productData = data;
                                cartProduct.setor = data.setor;
                                CarrinhoModelo.of(context)
                                    .addCartItem(cartProduct, data.quantidadeE);

                                setState(() {
                                  animeAddCarrinho = true;
                                });

                                Future.delayed(Duration(milliseconds: 450))
                                    .then((_) {
                                  setState(() {
                                    animeAddCarrinho = false;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        FadeRoute(page: PrincipalTela()),
                                        (context) => false);

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CarrinhoTela()));
                                  });
                                });
                              },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 50),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: data.quantidadeE == 0
                                ? CupertinoColors.destructiveRed
                                : animeAddCarrinho == true
                                    ? CupertinoColors.activeGreen
                                    : Color(corDark),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            data.quantidadeE == 0
                                ? CupertinoIcons.minus_circled
                                : animeAddCarrinho == true
                                    ? CupertinoIcons.check_mark
                                    : Icons.add,
                            color: Color(corPrincipal),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          data.quantidadeE == 0
                              ? "Indisponível"
                              : precoPromocao.text,
                          style: fontBold14Dark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
