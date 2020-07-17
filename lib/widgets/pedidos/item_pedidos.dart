import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/telas/pagamento_MP.dart';
import 'package:pretainformatica/widgets/pedidos/status_pagamento.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';

class ItemPedidosItens extends StatefulWidget {
  final String orderId;

  ItemPedidosItens(this.orderId);

  @override
  _ItemPedidosItensState createState() => _ItemPedidosItensState();
}

class _ItemPedidosItensState extends State<ItemPedidosItens> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CarrinhoModelo>(
      builder: (context, child, model) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            elevation: 6,
            shadowColor: Color(corCinza).withAlpha(110),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              margin: EdgeInsets.all(15),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection("ordens")
                      .document(widget.orderId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    else {
                      int status = snapshot.data["status"];

                      String payIdPost = snapshot.data["payInfo"]["id"];
                      var totalMask =
                          new MoneyMaskedTextController(leftSymbol: 'R\$ ');
                      totalMask.updateValue(snapshot.data["preco_total"]);

                      return Stack(
                        children: [
                          Positioned(
                            right: 10,
                            top: 10,
                            child: GestureDetector(
                              onTap: () {
                                FlutterOpenWhatsapp.sendSingleMessage(
                                  "552430653161",
                                  "*[DÚVIDAS]*\nOlá, tenho dúvidas/sugestões sobre meu pedido:\nID: *${snapshot.data.documentID}*\nData: *${formatDate(snapshot.data['data'].toDate(), [
                                    dd,
                                    '/',
                                    mm,
                                    '/',
                                    yyyy,
                                    ' - ',
                                    HH,
                                    ':',
                                    nn
                                  ])}*\nCliente: *${snapshot.data['usuario_nome']}*\nPreço Total: *${totalMask.text}*",
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: CupertinoColors.activeGreen,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Image.asset("assets/icones/whatsapp.png"),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${snapshot.data.documentID}',
                                style: fontBold16Dark,
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                '${formatDate(snapshot.data['data'].toDate(), [
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy,
                                  ' - ',
                                  HH,
                                  ':',
                                  nn
                                ])}',
                                style: fontLight16Dark,
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                "Descrição do pedido",
                                style: fontBold14Dark,
                              ),
                              Text(
                                _buildProductsText(snapshot.data),
                                style: fontLight16Grey,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _buildCircle("1", "Preparação", status, 1),
                                    Container(
                                      height: 1.0,
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                      color: Colors.grey[500],
                                    ),
                                    _buildCircle("2", "Transporte", status, 2),
                                    Container(
                                      height: 1.0,
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                      color: Colors.grey[500],
                                    ),
                                    _buildCircle("3", "Entrega", status, 3),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      height: 38,
                                      width: MediaQuery.of(context).size.width,
                                      child: CupertinoButton(
                                        padding: EdgeInsets.all(0),
                                        color: Color(corDark),
                                        onPressed: status == 1
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  child:
                                                      new CupertinoAlertDialog(
                                                    title:
                                                        Text("Cancelar Pedido"),
                                                    content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            "Deseja realmente cancelar seu pedido?")),
                                                    actions: <Widget>[
                                                      new CupertinoButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: new Text("Não"),
                                                      ),
                                                      new CupertinoButton(
                                                        onPressed: () {
                                                          model.pararPedido(
                                                              '${snapshot.data.documentID}');
                                                          FlutterOpenWhatsapp
                                                              .sendSingleMessage(
                                                            "552430653161",
                                                            "*[CANCELAMENTO]*\nOlá, gostaria de cancelar meu pedido:\nID: *${snapshot.data.documentID}*\nData: *${formatDate(snapshot.data['data'].toDate(), [
                                                              dd,
                                                              '/',
                                                              mm,
                                                              '/',
                                                              yyyy,
                                                              ' - ',
                                                              HH,
                                                              ':',
                                                              nn
                                                            ])}*\nCliente: *${snapshot.data['usuario_nome']}*\nPreço Total: *${totalMask.text}*",
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: new Text("Sim"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            : null,
                                        child: Text("Cancelar"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      height: 38,
                                      width: MediaQuery.of(context).size.width,
                                      child: snapshot.data['payInfo']['id'] ==
                                                  "00000" ||
                                              snapshot.data['payInfo']
                                                      ['result'] ==
                                                  "canceled" ||
                                              snapshot.data['payInfo']['id'] ==
                                                  "null" ||
                                              snapshot.data['payInfo']['id'] ==
                                                  null
                                          ? CupertinoButton(
                                              padding: EdgeInsets.all(0),
                                              color: CupertinoColors.activeBlue,
                                              onPressed:
                                                  status > 1 || status == 0
                                                      ? null
                                                      : () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) => PagamentoMPScreen(
                                                                  refIdMP: snapshot
                                                                          .data[
                                                                      'refIdMP'],
                                                                  docId: widget
                                                                      .orderId),
                                                            ),
                                                          );
                                                        },
                                              child: Text("Pagar"),
                                            )
                                          : CupertinoButton(
                                              padding: EdgeInsets.all(0),
                                              color:
                                                  CupertinoColors.systemGreen,
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      StatusPagamento(
                                                    payId: payIdPost,
                                                  ),
                                                );
                                              },
                                              child: Text("Status"),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
        );
      },
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "";
    for (LinkedHashMap p in snapshot.data["produtos"]) {
      text +=
          "${p["quantidade"]} x ${p["produto"]["titulo"]} (R\$ ${p["produto"]["preco"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["preco_total"].toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Color(corDark);
      child = Text(
        title,
        style: fontBold14White,
      );
    } else if (status == thisStatus) {
      backColor = Color(corPrincipal);
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: fontBold14Dark,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(
          subtitle,
          style: fontLight14Grey,
        )
      ],
    );
  }
}
