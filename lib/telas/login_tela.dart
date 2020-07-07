import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/cadastro_tela.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';
import 'package:pretainformatica/widgets/sistema/campo_texto.dart';
import 'package:pretainformatica/widgets/sistema/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginTela extends StatefulWidget {
  @override
  _LoginTelaState createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // void initState() {
  //   Future.delayed(Duration(seconds: 2)).then((_) {
  //     Navigator.of(context).pop();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(corDark),
        title: Text("Bem Vindo", style: fontHeavy20White),
        actions: <Widget>[
          CupertinoButton(
              child: Text(
                "Cadastro",
                style: fontBold16White,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CadastroTela()));
              })
        ],
      ),
      backgroundColor: Color(corDark),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ScopedModelDescendant<UsuarioModelo>(
          builder: (context, child, model) {
            return model.carregando == true
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(corDark)),
                      backgroundColor: Color(corAccent),
                      strokeWidth: 2,
                    ),
                  )
                : Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        color: Color(corDark),
                        child: FlareActor(
                          "assets/animacoes/pretainformatica_background.flr",
                          animation: "animacao",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width / 1.12,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/logo/logo.png",
                                    height: 160,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Olá! Faça login para continuar.",
                                      style: fontRegular25White,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: CampoTexto(
                                        controller: _emailController,
                                        hintText: "email",
                                        inputType: TextInputType.emailAddress,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        passTrue: false,
                                        varValue: null,
                                        readOnly: false),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: CampoTexto(
                                        controller: _passController,
                                        hintText: "senha",
                                        inputType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        passTrue: true,
                                        varValue: null,
                                        readOnly: false),
                                  ),
                                  SizedBox(height: 5),
                                  BotaoPrincipal(
                                      label: "Entrar",
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              1.3,
                                      function: () {
                                        if (_formKey.currentState.validate()) {}
                                        model.login(
                                          email: _emailController.text,
                                          pass: _passController.text,
                                          onSuccess: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PrincipalTela()));
                                          },
                                          onFail: () {
                                            Scaffold.of(context).showSnackBar(
                                                snackBarErroEmail);
                                          },
                                        );
                                      }),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
