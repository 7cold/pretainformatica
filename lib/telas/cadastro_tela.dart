import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';
import 'package:pretainformatica/widgets/sistema/campo_texto.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastroTela extends StatefulWidget {
  @override
  _CadastroTelaState createState() => _CadastroTelaState();
}

class _CadastroTelaState extends State<CadastroTela> {
  final _formKey = GlobalKey<FormState>();

  bool _cTermos = false;
  TextEditingController _cNome = TextEditingController();
  var _cCPF = MaskedTextController(mask: '000.000.000-00');
  TextEditingController _cEmail = TextEditingController();
  TextEditingController _cSenha = TextEditingController();
  TextEditingController _cEndereco = TextEditingController();
  TextEditingController _cEnderecoNum = TextEditingController();
  TextEditingController _cEnderecoCidade = TextEditingController();
  TextEditingController _cEnderecoBairro = TextEditingController();
  var _cCEP = MaskedTextController(mask: '00000-000');
  var _cCelular = MaskedTextController(mask: '(00) 00000-0000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cadastro"),
        backgroundColor: Color(corDark),
      ),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          return model.carregando == true
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 25),
                          GestureDetector(
                            onTap: () {
                              model.getImage();
                            },
                            child: model.imageFile == null
                                ? Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Color(corCinza).withAlpha(50),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/icones/user.png",
                                        scale: 10,
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      model.imageFile,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                    ),
                                  ),
                          ),
                          SizedBox(height: 25),
                          CampoTexto(
                              controller: _cNome,
                              hintText: "nome completo",
                              inputType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              passTrue: false,
                              varValue: _cNome.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo Obrigatório*';
                                }
                              },
                              readOnly: false),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cCPF,
                              hintText: "cpf",
                              inputType: TextInputType.number,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty || value.length < 14) {
                                  return 'Campo Obrigatório*';
                                }
                              },
                              readOnly: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(),
                          ),
                          CampoTexto(
                              controller: _cEmail,
                              hintText: "email",
                              inputType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              varValue: _cEmail.text,
                              validator: (value) {
                                if (value.isEmpty || !value.contains("@")) {
                                  return 'Email inválido*';
                                }
                              },
                              readOnly: false),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cSenha,
                              hintText: "senha",
                              inputType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              passTrue: true,
                              varValue: _cSenha.text,
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return 'Senha inválida* Minímo de 6 dígitos';
                                }
                              },
                              readOnly: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(),
                          ),
                          CampoTexto(
                              controller: _cEndereco,
                              hintText: "endereco",
                              inputType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo inválida*';
                                }
                              },
                              readOnly: false),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cEnderecoNum,
                              hintText: "numero",
                              inputType: TextInputType.number,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo inválida*';
                                }
                              },
                              readOnly: false),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cCEP,
                              maxLines: 9,
                              hintText: "cep",
                              inputType: TextInputType.number,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo inválida*';
                                }
                              },
                              onChanged: (value) {
                                value.length >= 9
                                    ? CarrinhoModelo.of(context)
                                        .getEndereco(value)
                                        .then((result) {
                                        setState(() {
                                          _cEnderecoCidade.text =
                                              result.cidade.nome.toString();

                                          result.bairro == null
                                              ? _cEnderecoBairro.text = ""
                                              : _cEnderecoBairro.text =
                                                  result.bairro.toString();
                                        });
                                      }).catchError((e) {
                                        setState(() {
                                          _cEnderecoCidade.text =
                                              "CEP Inválido";
                                          _cEnderecoBairro.text =
                                              "CEP Inválido";
                                        });
                                      })
                                    : setState(() {
                                        _cEnderecoCidade.text = "CEP Inválido";
                                        _cEnderecoBairro.text = "CEP Inválido";
                                      });
                              },
                              readOnly: false),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cEnderecoCidade,
                              hintText: "cidade",
                              inputType: TextInputType.number,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              suffixIcon: _cEnderecoCidade.text == null ||
                                      _cEnderecoCidade.text == "CEP Inválido"
                                  ? CupertinoActivityIndicator()
                                  : SizedBox(),
                              varValue: null,
                              readOnly: true),
                          SizedBox(height: 8),
                          CampoTexto(
                              controller: _cEnderecoBairro,
                              hintText: "bairro",
                              inputType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo inválida*';
                                }
                              },
                              readOnly: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(),
                          ),
                          CampoTexto(
                              controller: _cCelular,
                              hintText: "celular",
                              inputType: TextInputType.number,
                              textCapitalization: TextCapitalization.none,
                              passTrue: false,
                              varValue: null,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Campo inválida*';
                                }
                              },
                              readOnly: false),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Checkbox(
                                value: _cTermos,
                                onChanged: (bool value) {
                                  setState(() {
                                    _cTermos = value;
                                  });
                                },
                              ),
                              Text(
                                "Li e aceito os termos de uso do app.",
                                style: fontRegular16Dark,
                              )
                            ],
                          ),
                          BotaoPrincipal(
                            label: "Cadastrar",
                            minWidth: MediaQuery.of(context).size.width / 1.5,
                            function: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                model.imageFile == null
                                    ? null
                                    : model.downloadUrl =
                                        await model.uploadImage();

                                model.cadastro(
                                  usuarioData: {
                                    'nome': _cNome.text,
                                    'cpf': _cCPF.text,
                                    'email': _cEmail.text,
                                    'endereco': _cEndereco.text,
                                    'endereco_num': _cEnderecoNum.text,
                                    'endereco_bairro': _cEnderecoBairro.text,
                                    'endereco_cidade': _cEnderecoCidade.text,
                                    'cep': _cCEP.text,
                                    'celular': _cCelular.text,
                                    'data_cadastro': Timestamp.now(),
                                    'imagem': model.imageFile == null
                                        ? "https://firebasestorage.googleapis.com/v0/b/pretainformatica-1c56f.appspot.com/o/configuracoes%2Fuser_NAOAPAGAR.png?alt=media&token=0c179c89-a294-4a76-9809-79fa72076486"
                                        : model.downloadUrl.toString(),
                                  },
                                  pass: _cSenha.text,
                                  onSucess: () {
                                    print("ok");
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => PrincipalTela(),
                                        ),
                                        (Route<dynamic> route) => false);
                                  },
                                  onFail: () {
                                    print("erro");
                                    final snackBar = SnackBar(
                                      content: Text(
                                          "Ops! Algo está errado, tente novamente."),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(height: 25)
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
