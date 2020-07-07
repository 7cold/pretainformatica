import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/telas/carrinho_finalizar_tela.dart';
import 'package:pretainformatica/widgets/carrinho/item_carrinho.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/bottomAppBar.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoTela extends StatefulWidget {
  @override
  _CarrinhoTelaState createState() => _CarrinhoTelaState();
}

class _CarrinhoTelaState extends State<CarrinhoTela> {
  Timer timer;

  @override
  void initState() {
    timer = new Timer.periodic(Duration(seconds: 2), (Timer timer) {
      CarrinhoModelo.of(context).updatePrices();
      print("atualizando carrinho");
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
    return ScopedModelDescendant<CarrinhoModelo>(
      builder: (context, child, model) {
        double price = CarrinhoModelo.of(context).getProductsPrice();
        double discount = CarrinhoModelo.of(context).getDiscount();
        double ship = CarrinhoModelo.of(context).getShipPrice();

        double total = (price + ship - discount);
        var totalMask = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
        totalMask.updateValue(total);

        return Scaffold(
            appBar: appBar(context, "Carrinho", false),
            bottomNavigationBar: bottomAppBarCustomNav(
                context,
                price == 0.0
                    ? null
                    : () {
                        timer.cancel();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CarrinhoFinalizarTela()));
                      },
                price != 0.0
                    ? Text(
                        totalMask.text,
                        style: fontBold14Dark,
                      )
                    : CupertinoActivityIndicator(),
                "Continuar"),
            body: model.products.length == 0
                ? Center(
                    child: Text(
                    "Nenhum produto, volte para continuar",
                    style: fontBold16Grey,
                  ))
                : ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: model.products.map((product) {
                          return ItemCarrinho(product);
                        }).toList(),
                      ),
                    ],
                  ));
      },
    );
  }
}
