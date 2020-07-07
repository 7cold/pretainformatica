import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/carrinho_tela.dart';
import 'package:pretainformatica/telas/login_tela.dart';
import 'package:pretainformatica/telas/pedidos_tela.dart';
import 'package:pretainformatica/telas/usuario_endereco_tela.dart';
import 'package:pretainformatica/telas/usuario_info_tela.dart';
import 'package:pretainformatica/telas/usuario_mensagens_tela.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';
import 'package:scoped_model/scoped_model.dart';

class UsuarioTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UsuarioModelo>(
      builder: (context, child, model) {
        return model.usuarioData['nome'] == null || model.carregando == true
            ? Scaffold(
                backgroundColor: Color(corPrincipal),
                body: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Color(corPrincipal),
                appBar: appBar(context, "Configurações", false),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //imagem
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              CupertinoActivityIndicator(),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          model.usuarioData['imagem']),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ],
                          ),
                          //nome
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
                            child: Text(
                              model.usuarioData['nome'],
                              style: fontBold20Dark,
                            ),
                          ),
                          //botao editar perfil
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: BotaoSecundario(
                              label: "Editar",
                              minWidth: MediaQuery.of(context).size.width / 1.8,
                              function: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UsuarioInfoTela()));
                              },
                            ),
                          ),
                          //menu de opcoes
                          Column(
                            children: <Widget>[
                              ItemMenu(
                                label: "Pedidos",
                                rota: PedidosTela(),
                                funcao: null,
                                funcaoVer: false,
                              ),
                              ItemMenu(
                                label: "Carrinho",
                                rota: CarrinhoTela(),
                                funcao: null,
                                funcaoVer: false,
                              ),
                              ItemMenu(
                                label: "Endereço",
                                funcao: null,
                                funcaoVer: false,
                                rota: UsuarioEnderecoTela(),
                              ),
                              ItemMenu(
                                label: "Mensagens",
                                funcao: null,
                                funcaoVer: false,
                                rota: UsuarioMensagensTela(),
                              ),
                              ItemMenu(
                                label: "Logout",
                                funcao: () async {
                                  await model.sair();

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => LoginTela(),
                                      ),
                                      (Route<dynamic> route) => false);
                                },
                                funcaoVer: true,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class ItemMenu extends StatelessWidget {
  final String label;
  final Widget rota;
  final bool funcaoVer;
  final Function funcao;

  const ItemMenu({Key key, this.label, this.rota, this.funcaoVer, this.funcao})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        funcaoVer == true
            ? funcao()
            : Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => rota));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    label,
                    style: fontLight16Dark,
                  ),
                  Icon(CupertinoIcons.right_chevron)
                ],
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
