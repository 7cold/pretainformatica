import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';

import 'package:scoped_model/scoped_model.dart';

class UsuarioEnderecoTela extends StatefulWidget {
  @override
  _UsuarioEnderecoTelaState createState() => _UsuarioEnderecoTelaState();
}

class _UsuarioEnderecoTelaState extends State<UsuarioEnderecoTela> {
  TextEditingController _cEndereco = TextEditingController();
  TextEditingController _cEnderecoNum = TextEditingController();
  TextEditingController _cEnderecoCidade = TextEditingController();
  TextEditingController _cEnderecoBairro = TextEditingController();
  var _cCEP = MaskedTextController(mask: '00000-000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Endereço", false),
      backgroundColor: Color(corPrincipal),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          buscarCep(String value) {
            print(value);
            if (value.length < 9) {
              _cEnderecoCidade.text = "";
              _cEnderecoBairro.text = "";
            } else {
              CarrinhoModelo.of(context).getEndereco(value).then((result) {
                _cEnderecoCidade.text = result.cidade.nome;
                _cEnderecoBairro.text = result.bairro;
              }).catchError((e) {
                _cEnderecoCidade.text = e;
              });
            }
          }

          editarUsuario() {
            model.editarEndereco(
              usuarioData: {
                "endereco": _cEndereco.text,
                "endereco_num": _cEnderecoNum.text,
                "endereco_cidade": _cEnderecoCidade.text,
                "endereco_bairro": _cEnderecoBairro.text,
                "cep": _cCEP.text,
              },
              onSucess: () async {
                print("ok");
                await model.carregarUsuarios();
                Future.delayed(Duration(milliseconds: 1150)).then((_) {
                  Navigator.of(context).pop();
                });
              },
              onFail: () {
                Navigator.of(context).pop();
              },
            );
          }

          return model.usuarioData['nome'] == null
              ? Center(
                  child: CupertinoButton(
                      child: Text("Atualizar"),
                      onPressed: () {
                        model.carregarUsuarios();
                      }),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Material(
                          elevation: 8,
                          shadowColor: Color(corCinza).withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, top: 25, right: 25, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Endereço de entrega",
                                        style: fontBold20Dark,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _cEndereco.text =
                                              model.usuarioData['endereco'];
                                          _cEnderecoNum.text =
                                              model.usuarioData['endereco_num'];
                                          _cEnderecoCidade.text = model
                                              .usuarioData['endereco_cidade'];
                                          _cEnderecoBairro.text = model
                                              .usuarioData['endereco_bairro'];
                                          _cCEP.text = model.usuarioData['cep'];
                                          showDialog(
                                            context: context,
                                            child: new CupertinoAlertDialog(
                                              title: Text("Editar"),
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    CupertinoTextField(
                                                      placeholder: "endereço",
                                                      controller: _cEndereco,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                    ),
                                                    SizedBox(height: 5),
                                                    CupertinoTextField(
                                                      placeholder: "número",
                                                      controller: _cEnderecoNum,
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    SizedBox(height: 5),
                                                    CupertinoTextField(
                                                      placeholder: "00000-000",
                                                      controller: _cCEP,
                                                      maxLength: 9,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      onChanged: (value) {
                                                        buscarCep(value);
                                                      },
                                                    ),
                                                    SizedBox(height: 5),
                                                    CupertinoTextField(
                                                      placeholder: "cidade",
                                                      controller:
                                                          _cEnderecoCidade,
                                                      readOnly: true,
                                                      suffix: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 5),
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    CupertinoTextField(
                                                      placeholder: "bairro",
                                                      controller:
                                                          _cEnderecoBairro,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                new CupertinoButton(
                                                  onPressed: () {
                                                    editarUsuario();
                                                  },
                                                  child: new Text("Salvar"),
                                                ),
                                                new CupertinoButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _cEndereco.text = "";
                                                    _cEnderecoNum.text = "";
                                                    _cEnderecoCidade.text = "";
                                                    _cEnderecoBairro.text = "";
                                                    _cCEP.text = "";
                                                  },
                                                  child: new Text("Cancelar"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.pencil,
                                          color: Color(corDark),
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Rua",
                                    style: fontBold16Dark,
                                  ),
                                  Text(
                                    model.usuarioData['endereco'] +
                                        ", " +
                                        model.usuarioData['endereco_num'],
                                    style: fontLight16Grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Bairro",
                                    style: fontBold16Dark,
                                  ),
                                  Text(
                                    model.usuarioData['endereco_bairro'],
                                    style: fontLight16Grey,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Cidade",
                                            style: fontBold16Dark,
                                          ),
                                          Text(
                                            model
                                                .usuarioData['endereco_cidade'],
                                            style: fontLight16Grey,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "CEP",
                                            style: fontBold16Dark,
                                          ),
                                          Text(
                                            model.usuarioData['cep'],
                                            style: fontLight16Grey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
