import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/telas/pagamento_MP.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';

class PedidosConfirmacaoTela extends StatefulWidget {
  final String orderId;
  final String prefIdMP;

  const PedidosConfirmacaoTela({Key key, this.orderId, this.prefIdMP})
      : super(key: key);

  @override
  _PedidosConfirmacaoTelaState createState() =>
      _PedidosConfirmacaoTelaState(orderId, prefIdMP);
}

class _PedidosConfirmacaoTelaState extends State<PedidosConfirmacaoTela> {
  final String orderId;
  final String prefIdMP;

  _PedidosConfirmacaoTelaState(this.orderId, this.prefIdMP);
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(corPrincipal),
        body: Center(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 220,
                        child: FlareActor(
                          "assets/animacoes/carrinho.flr",
                          animation: "carrinho",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 25),
                        child: Text(
                          "Pedido realizado com sucesso!",
                          style: fontHeavy20Grey,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Obrigado! Aguarde, em poucos minutos você receberá os dados da compra em seu Email, ou se preferir acesse o menu 'Meus Pedidos'",
                        style: fontLight16Dark,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Código do pedido: ',
                          style: fontBold18Grey,
                          children: <TextSpan>[
                            TextSpan(text: '$orderId', style: fontLight18Dark),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 30),
                      CupertinoButton(
                          color: CupertinoColors.activeBlue,
                          child: Text("Pagar Agora"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PagamentoMPScreen(
                                docId: orderId,
                                refIdMP: prefIdMP,
                              ),
                            ));
                          }),
                      SizedBox(height: 15),
                      BotaoPrincipal(
                        label: "Continuar Comprando",
                        function: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => PrincipalTela(),
                              ),
                              (Route<dynamic> route) => false);
                        },
                        minWidth: MediaQuery.of(context).size.width / 2.2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
