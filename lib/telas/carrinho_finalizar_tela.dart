import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/pedidos_confirmacao_tela.dart';
import 'package:pretainformatica/widgets/carrinho/carrinho_valor.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/bottomAppBar.dart';
import 'package:pretainformatica/widgets/sistema/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoFinalizarTela extends StatefulWidget {
  @override
  _CarrinhoFinalizarTelaState createState() => _CarrinhoFinalizarTelaState();
}

handleClickMe(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Ops, algo deu errado!'),
        content: Text('Por favor, verifique seu cep e tente novamente.'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Editar Cep'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('Voltar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _CarrinhoFinalizarTelaState extends State<CarrinhoFinalizarTela> {
  Timer timer;

  @override
  void initState() {
    timer = new Timer.periodic(Duration(seconds: 3), (Timer timer) {
      CarrinhoModelo.of(context).updatePrices();
      print("atualizando finalizar");
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    print("cancel");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double price = CarrinhoModelo.of(context).getProductsPrice();
    double discount = CarrinhoModelo.of(context).getDiscount();
    double ship = CarrinhoModelo.of(context).getShipPrice();

    double total = (price + ship - discount);
    var totalMask = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
    totalMask.updateValue(total);

    return Scaffold(
      appBar: appBar(context, "Finalizar Pedido", false),
      bottomNavigationBar: bottomAppBarCustomNav(
          context,
          CarrinhoModelo.of(context).carregandoEntrega == true ||
                  CarrinhoModelo.of(context).isLoading == true ||
                  totalMask.text == "R\$ 0,00"
              ? null
              : () async {
                  Map prefIdMP =
                      await CarrinhoModelo.of(context).preferenceGetMP();
                  String orderId =
                      await CarrinhoModelo.of(context).finishOrder();
                  if (orderId != null) {
                    await UsuarioModelo.of(context).sendEmail(
                        "Obrigado por comprar com a gente! Abaixo segue o número de seu pedido. Caso tenha dúvidas entre em contato pelo whatsapp da nossa loja: (24)-3065-3161 \nNúmero do pedido: $orderId \nEndereço: R. Teresa, 1515 - Alto da Serra, Petrópolis - RJ, 25635-530 - Loja 95",
                        UsuarioModelo.of(context).usuarioData['email'],
                        "Compra Efetuada com sucesso!");
                    await UsuarioModelo.of(context).sendEmailVendedor(orderId);
                    timer.cancel();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PedidosConfirmacaoTela(
                          orderId: orderId,
                          prefIdMP: prefIdMP['response']['id'],
                        ),
                      ),
                    );
                  }
                },
          totalMask.text != "R\$ 0,00"
              ? Text(
                  totalMask.text,
                  style: fontBold16Dark,
                )
              : CupertinoActivityIndicator(),
          "Finalizar"),
      body: CarrinhoModelo.of(context).isLoading == true ||
              UsuarioModelo.of(context).carregando == true
          ? Center(
              child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 220,
                        child: FlareActor(
                          "assets/animacoes/carregando.flr",
                          animation: "Untitled",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Estamos preparando seu pedido!",
                        style: fontBold18Grey,
                      )
                    ],
                  ),
                ),
              ],
            ))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ScopedModelDescendant<UsuarioModelo>(
                    builder: (context, child, model) {
                      return model.usuarioData['nome'] == null
                          ? Center(child: CupertinoActivityIndicator())
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Endereço de entrega",
                                    style: fontHeavy18Grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          model.usuarioData['endereco_bairro'] +
                                              " - " +
                                              model.usuarioData[
                                                  'endereco_cidade'],
                                          style: fontLight16Dark,
                                        ),
                                        Text(
                                          model.usuarioData['endereco'] +
                                              " ," +
                                              model.usuarioData['endereco_num'],
                                          style: fontLight16Dark,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        child: new CupertinoAlertDialog(
                                          title: Text("Usar cupom de desconto"),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CupertinoTextField(
                                              onSubmitted: (text) {
                                                Firestore.instance
                                                    .collection('cupons')
                                                    .document(text)
                                                    .get()
                                                    .then((docSnap) {
                                                  if (docSnap.data != null) {
                                                    CarrinhoModelo.of(context)
                                                        .setCoupon(
                                                            text,
                                                            docSnap.data[
                                                                'porcentagem']);
                                                    print('ok');
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    CarrinhoModelo.of(context)
                                                        .setCoupon(null, 0);
                                                    Navigator.of(context).pop();
                                                    Scaffold.of(context)
                                                        .showSnackBar(
                                                            snackBarErro);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: new Text("Cancelar"))
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color:
                                              Color(corAccent).withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            CarrinhoModelo.of(context)
                                                        .discountPercentage ==
                                                    0
                                                ? "Adicionar cupom"
                                                : CarrinhoModelo.of(context)
                                                    .couponCode,
                                            style: fontBold14Dark,
                                          ),
                                          FlutterTicketWidget(
                                            height: 25,
                                            width: 100,
                                            isCornerRounded: false,
                                            color: Color(corAccent),
                                            child: Center(
                                                child: Text(
                                                    CarrinhoModelo.of(context)
                                                                .discountPercentage ==
                                                            0
                                                        ? "%"
                                                        : CarrinhoModelo.of(
                                                                    context)
                                                                .discountPercentage
                                                                .toString() +
                                                            " %",
                                                    style: fontBold14Dark)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(thickness: 0.8),
                                ],
                              ),
                            );
                    },
                  ),
                  ScopedModelDescendant<CarrinhoModelo>(
                    builder: (context, child, model) {
                      if (model.products == null ||
                          model.products.length == 0) {
                        return CupertinoActivityIndicator();
                      } else {
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Tipo de Entrega/Retirada",
                                    textAlign: TextAlign.start,
                                    style: fontHeavy18Grey,
                                  ),
                                  SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ItemTipoRetirada(
                                        image: "assets/icones/pegar.png",
                                        label: "Irei Buscar",
                                        tipo: "irei_buscar",
                                      ),
                                      ItemTipoRetirada(
                                        image: "assets/icones/entregador.png",
                                        label: "Entregar",
                                        tipo: "entregar",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Divider(thickness: 0.8),
                            ),
                            CarrinhoValor(),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
    );
  }
}

class ItemTipoRetirada extends StatelessWidget {
  final String tipo;
  final String label;
  final String image;

  const ItemTipoRetirada({Key key, this.tipo, this.label, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CarrinhoModelo.of(context).setShipping(tipo);
        if (CarrinhoModelo.of(context).getShipping() == "entregar") {
          CarrinhoModelo.of(context)
              .getEndereco(UsuarioModelo.of(context).usuarioData['cep'])
              .then((endereco) {
            return CarrinhoModelo.of(context)
                .calcularEntrega(endereco.latitude, endereco.longitude);
          }).catchError((e) {
            CarrinhoModelo.of(context).setShipping("irei_buscar");
            CarrinhoModelo.of(context).setShippingPrice(0);
            handleClickMe(context);
          });
        } else {
          CarrinhoModelo.of(context).setShippingPrice(0);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 4,
        width: MediaQuery.of(context).size.width / 4,
        decoration: CarrinhoModelo.of(context).getShipping() == tipo
            ? BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(8),
              )
            : BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image,
              height: MediaQuery.of(context).size.width / 8,
            ),
            Text(
              label,
              style: fontBold14Dark,
            ),
          ],
        ),
      ),
    );
  }
}
