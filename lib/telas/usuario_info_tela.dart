import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/botao.dart';
import 'package:pretainformatica/widgets/sistema/campo_texto.dart';
import 'package:pretainformatica/widgets/sistema/snackbar.dart';
import 'package:scoped_model/scoped_model.dart';

class UsuarioInfoTela extends StatefulWidget {
  @override
  _UsuarioInfoTelaState createState() => _UsuarioInfoTelaState();
}

class _UsuarioInfoTelaState extends State<UsuarioInfoTela> {
  final _formKey = GlobalKey<FormState>();
  var _cCelular = MaskedTextController(mask: '(00) 00000-0000');
  TextEditingController _cNome = TextEditingController();
  var _cCPF = MaskedTextController(mask: '000.000.000-00');

  // File imageFile;
  // StorageUploadTask uploadTask;
  // String downloadUrl;
  // double porcentagem = 0;

  // StorageReference reference = FirebaseStorage.instance.ref().child(
  //     'usuarios/img_perfil/${Path.basename(DateTime.now().toString() + '.jpg')}');

  // Future getImage() async {
  //   File image;
  //   image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 40);
  //   setState(() {
  //     imageFile = image;
  //   });
  // }

  // Future uploadImage() async {
  //   StorageUploadTask uploadTask = reference.putFile(imageFile);

  //   final StreamSubscription<StorageTaskEvent> streamSubscription =
  //       uploadTask.events.listen((event) {
  //     //print('EVENT ${event.type}');
  //     setState(() {
  //       porcentagem = event.snapshot.bytesTransferred.toDouble() /
  //           event.snapshot.totalByteCount.toDouble();

  //       //print(_porcentagem);
  //     });
  //   });

  //   await uploadTask.onComplete;

  //   streamSubscription.cancel();

  //   var downloadUrl = await reference.getDownloadURL();

  //   return downloadUrl;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Editar", false),
      backgroundColor: Color(corPrincipal),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          _cNome.text = model.usuarioData['nome'].toString();
          _cCPF.text = model.usuarioData['cpf'].toString();
          _cCelular.text = model.usuarioData['celular'].toString();

          return model.usuarioData['nome'] == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                model.getImage();
                              },
                              child: model.imageFile == null
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 20),
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                model.usuarioData['imagem']),
                                            fit: BoxFit.cover),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.file(
                                              model.imageFile,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                              filterQuality:
                                                  FilterQuality.medium,
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          onPressed: () async {
                                            model.downloadUrl =
                                                await model.uploadImage();
                                            model.editarUsuario(
                                                usuarioData: {
                                                  'imagem': model.downloadUrl
                                                      .toString(),
                                                },
                                                onSucess: () {
                                                  model.imageFile = null;
                                                  model.porcentagem = 0;
                                                  Navigator.of(context).pop();
                                                  Scaffold.of(context)
                                                      .showSnackBar(snackBarOk);
                                                },
                                                onFail: () {
                                                  Navigator.of(context).pop();
                                                  Scaffold.of(context)
                                                      .showSnackBar(
                                                          snackBarErro);
                                                });
                                            model.carregarUsuarios();
                                          },
                                          child: Text("Upload"),
                                        ),
                                        Center(
                                          child: new LinearPercentIndicator(
                                            lineHeight: 15,
                                            backgroundColor:
                                                Color(corCinza).withAlpha(100),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            alignment: MainAxisAlignment.center,
                                            percent: model.porcentagem,
                                            center: new Text(
                                              (model.porcentagem * 100)
                                                      .toString() +
                                                  "%",
                                              style: fontLight14Dark,
                                            ),
                                            progressColor: Color(corAccent),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(),
                                ),
                                CampoTexto(
                                    controller: _cNome,
                                    hintText: "nome completo",
                                    inputType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(),
                                ),
                                BotaoPrincipal(
                                  label: "Salvar",
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.5,
                                  function: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      model.editarUsuario(
                                        usuarioData: {
                                          'nome': _cNome.text,
                                          'cpf': _cCPF.text,
                                          'celular': _cCelular.text,
                                          'imagem': model.downloadUrl == null
                                              ? model.usuarioData['imagem']
                                              : model.downloadUrl.toString(),
                                        },
                                        onSucess: () {
                                          Scaffold.of(context)
                                              .showSnackBar(snackBarOk);
                                        },
                                        onFail: () {
                                          Scaffold.of(context)
                                              .showSnackBar(snackBarErro);
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
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
