import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';

bottomAppBarCustom(context, ProdutoData product, Function funcaoBotao) {
  var precoTotalMask = new MoneyMaskedTextController(leftSymbol: 'R\$ ');
  precoTotalMask.updateValue(product.precoPromocao);
  return BottomAppBar(
    elevation: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(corPrincipal),
              ),
              child: Icon(
                Icons.room_service,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                precoTotalMask.text,
                style: fontBold16Dark,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: BotaoPrincipal(
            function: funcaoBotao,
            label: "Add ao Carrinho",
            minWidth: MediaQuery.of(context).size.width / 1.8,
          ),
        )
      ],
    ),
  );
}

bottomAppBarCustomNav(
    context, Function funcaoBotao, Widget preco, String label) {
  return BottomAppBar(
    elevation: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(corPrincipal),
              ),
              child: Icon(
                Icons.room_service,
                size: 20,
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: preco)
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: BotaoPrincipal(
            function: funcaoBotao,
            label: label,
            minWidth: MediaQuery.of(context).size.width / 1.8,
          ),
        )
      ],
    ),
  );
}
