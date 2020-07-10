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

class ItemCarrinho extends StatelessWidget {
  final CarrinhoProdutos cartProduct;

  ItemCarrinho(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildProducts(DocumentSnapshot doc) {
      var precoTotalMask = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
      precoTotalMask.updateValue(
          cartProduct.productData.precoPromocao * cartProduct.quantidade);

      return Column(
        children: <Widget>[
          SizedBox(height: 10),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              //imagem
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: NetworkImage(
                          cartProduct.productData.imagem,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              //conteudo
              Flexible(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        //quantidade
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              cartProduct.quantidade.toString() + "X",
                              style: fontBold14Dark,
                            ),
                          ),
                        ),
                        //titulo
                        Flexible(
                          flex: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              cartProduct.productData.titulo,
                              style: fontBold14Dark,
                            ),
                          ),
                        ),
                        //preco
                        Flexible(
                          flex: 4,
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              precoTotalMask.text,
                              style: fontBold14Grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //categoria
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconCategoria(cartProduct: cartProduct),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconMarca(cartProduct: cartProduct),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                    //quantidade
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: cartProduct.quantidade > 1
                                  ? Color(corDark)
                                  : CupertinoColors.inactiveGray),
                          onPressed: cartProduct.quantidade > 1
                              ? () {
                                  CarrinhoModelo.of(context)
                                      .decProduct(cartProduct);
                                  CarrinhoModelo.of(context).incEstoque(
                                      cartProduct, doc.data['quantidade_e']);
                                }
                              : null,
                        ),
                        Text(
                          cartProduct.quantidade.toString(),
                          style: fontBold14Dark,
                        ),
                        //verificar se tem em estoque
                        doc.data['quantidade_e'] < 1
                            ? IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: CupertinoColors.inactiveGray,
                                ),
                                onPressed: null,
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Color(corDark),
                                ),
                                onPressed: () {
                                  CarrinhoModelo.of(context)
                                      .incProduct(cartProduct);

                                  CarrinhoModelo.of(context).decEstoque(
                                      cartProduct, doc.data['quantidade_e']);
                                },
                              ),
                        IconButton(
                          onPressed: () {
                            CarrinhoModelo.of(context)
                                .removeCartItem(cartProduct);
                            CarrinhoModelo.of(context).incQuandoRemovido(
                                cartProduct, doc.data['quantidade_e']);
                          },
                          icon: Icon(
                            CupertinoIcons.delete,
                            size: 28,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.8,
          ),
        ],
      );
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance
              .collection(cartProduct.setor)
              .document(cartProduct.categoria)
              .collection('itens')
              .document(cartProduct.pid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              cartProduct.productData = ProdutoData.fromDocument(snapshot.data);
              return _buildProducts(snapshot.data);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ));
  }
}

class IconCategoria extends StatelessWidget {
  final CarrinhoProdutos cartProduct;

  const IconCategoria({Key key, this.cartProduct}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
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
        SizedBox(width: 5),
        Text(
          cartProduct.categoria.toUpperCase(),
          style: fontBold14Dark,
        ),
      ],
    );
  }
}

class IconMarca extends StatelessWidget {
  final CarrinhoProdutos cartProduct;

  const IconMarca({Key key, this.cartProduct}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
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
        SizedBox(width: 5),
        Text(
          cartProduct.productData.marca,
          style: fontBold14Dark,
        ),
      ],
    );
  }
}
