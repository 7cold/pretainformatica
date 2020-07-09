import 'dart:async';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/carrinho_data.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/carrinho_tela.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/telas/usuario_tela.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/bottomAppBar.dart';
import 'package:pretainformatica/widgets/sistema/nav_transition.dart';

class ProdutosDetalhes extends StatefulWidget {
  final ProdutoData product;
  final String categoria;
  final int qtdEstoque;

  const ProdutosDetalhes(
    this.product,
    this.categoria,
    this.qtdEstoque,
  );

  @override
  _ProdutosDetalhesState createState() =>
      _ProdutosDetalhesState(product, categoria, qtdEstoque);
}

class _ProdutosDetalhesState extends State<ProdutosDetalhes> {
  final ProdutoData product;
  final String categoria;
  final int qtdEstoque;

  _ProdutosDetalhesState(
    this.product,
    this.categoria,
    this.qtdEstoque,
  );

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    var precoNormal = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
    precoNormal.updateValue(product.precoNormal);

    var precoPromocao = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
    precoPromocao.updateValue(product.precoPromocao);

    return Scaffold(
      appBar: appBar(context, product.titulo, true),
      bottomNavigationBar: bottomAppBarCustom(context, product, () {
        CarrinhoProdutos cartProduct = CarrinhoProdutos();
        cartProduct.quantidade = 1;
        cartProduct.pid = product.id;
        cartProduct.categoria = categoria.toLowerCase();
        cartProduct.productData = product;
        cartProduct.setor = product.setor;
        CarrinhoModelo.of(context)
            .addCartItem(cartProduct, product.quantidadeE);

        Navigator.pushAndRemoveUntil(
            context, FadeRoute(page: PrincipalTela()), (context) => false);

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CarrinhoTela()));
      }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            //imagens
            Hero(
              tag: product.imagem,
              child: Container(
                height: 200,
                color: Colors.white,
                child: Carousel(
                  animationCurve: Curves.elasticOut,
                  boxFit: BoxFit.contain,
                  autoplay: false,
                  dotSize: 0.0,
                  dotSpacing: 15,
                  dotBgColor: Colors.transparent,
                  dotColor: Color(corDark),
                  dotIncreasedColor: Color(corPrincipal),
                  images: product.listaImagens.map((url) {
                    return (NetworkImage(url));
                  }).toList(),
                ),
              ),
            ),

            //titulo preco
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //color: Colors.amber,
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: Text(
                      product.titulo,
                      style: w < 350 ? fontHeavy16Dark : fontHeavy20Dark,
                    ),
                  ),
                  Text(
                    precoPromocao.text,
                    style: w < 350 ? fontHeavy16Dark : fontHeavy20Dark,
                  ),
                ],
              ),
            ),

            //categoria preco antigo
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(corAccent),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.flag,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        categoria.toUpperCase(),
                        style: fontBold16Dark,
                      ),
                    ],
                  ),
                  product.precoNormal.toString() ==
                          product.precoPromocao.toString()
                      ? SizedBox()
                      : Text(
                          precoNormal.text,
                          style: w < 350 ? fontBold14Grey : fontBold18GreyPromo,
                        ),
                ],
              ),
            ),

            //marca
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(corAccent),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.copyright,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        product.marca,
                        style: fontBold16Dark,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(corAccent),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.weightHanging,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        product.kg.toString() + " kg",
                        style: fontBold16Dark,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //descricao
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  product.descricao,
                  style: fontLight16Dark,
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            //tags
            SizedBox(
              height: 50,
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 15),
                  scrollDirection: Axis.horizontal,
                  children: product.tags.map((resultTag) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(corDark),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            resultTag,
                            style: fontBold14White,
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
