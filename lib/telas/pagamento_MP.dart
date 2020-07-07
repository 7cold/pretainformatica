import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/telas/pedidos_tela.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/widgets/sistema/nav_transition.dart';
import 'package:scoped_model/scoped_model.dart';

//const publicKey = "TEST-8a277242-00cd-41d5-82fa-d27eed06045f";
const publicKey = "APP_USR-0ab7aa1c-574b-4819-bd0b-f2fc0d85e454";
int resultadoMP = 0;

class PagamentoMPScreen extends StatefulWidget {
  final refIdMP;
  final docId;

  const PagamentoMPScreen({Key key, this.refIdMP, this.docId})
      : super(key: key);

  @override
  _PagamentoMPScreenState createState() => _PagamentoMPScreenState();
}

class _PagamentoMPScreenState extends State<PagamentoMPScreen> {
  @override
  Widget build(BuildContext context) {
    print(resultadoMP);
    print(widget.refIdMP);
    return ScopedModelDescendant<CarrinhoModelo>(
      builder: (context, child, model) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Color(corPrincipal),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/icones/mercado-pago.png",
                    scale: 4,
                  ),
                  SizedBox(height: 50),
                  CupertinoButton(
                    minSize: 50,
                    color: CupertinoColors.systemBlue,
                    child: Text(resultadoMP == null || resultadoMP == 0
                        ? "AVANÇAR"
                        : "MEUS PEDIDOS"),
                    onPressed: resultadoMP == null || resultadoMP == 0
                        ? () async {
                            var result =
                                await MercadoPagoMobileCheckout.startCheckout(
                              publicKey,
                              widget.refIdMP,
                            );
                            print(result.id);
                            await model.createPayInfo(widget.docId, result.id);
                            setState(() {
                              resultadoMP = result.id;
                            });
                          }
                        : () {
                            setState(() {
                              resultadoMP = 0;
                            });

                            Navigator.pushAndRemoveUntil(
                                context,
                                FadeRoute(page: PrincipalTela()),
                                (context) => false);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PedidosTela()),
                            );
                          },
                  ),
                  resultadoMP == null || resultadoMP == 0
                      ? CupertinoButton(
                          child: Text(
                            "Voltar",
                            style: TextStyle(color: CupertinoColors.activeBlue),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                      : SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
