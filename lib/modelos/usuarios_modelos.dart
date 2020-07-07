import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path/path.dart' as Path;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class UsuarioModelo extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  bool carregando = false;
  Map<String, dynamic> usuarioData = Map();
  File imageFile;
  StorageUploadTask uploadTask;
  String downloadUrl;
  double porcentagem = 0;
  StorageReference reference = FirebaseStorage.instance.ref().child(
      'usuarios/img_perfil/${Path.basename(DateTime.now().toString() + '.jpg')}');

  final smtpServer = gmail("pretainformatica.7cold.co@gmail.com", "123leo123");

  static UsuarioModelo of(BuildContext context) =>
      ScopedModel.of<UsuarioModelo>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    carregarUsuarios();
  }

  void cadastro({
    @required Map<String, dynamic> usuarioData,
    @required String pass,
    @required VoidCallback onSucess,
    @required VoidCallback onFail,
  }) {
    carregando = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: usuarioData['email'], password: pass)
        .then((result) async {
      firebaseUser = result.user;
      await _savarUsuario(usuarioData, firebaseUser.uid);

      onSucess();
      carregando = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      carregando = false;
      notifyListeners();
    });
  }

  bool verifLogado() {
    return firebaseUser != null;
  }

  void login({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    carregando = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((result) async {
      firebaseUser = result.user;

      await carregarUsuarios();

      onSuccess();
      carregando = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      carregando = false;
      notifyListeners();
    });
  }

  void editarEndereco({
    @required Map<String, dynamic> usuarioData,
    @required VoidCallback onSucess,
    @required VoidCallback onFail,
  }) {
    notifyListeners();

    _editarUsuario(usuarioData).then((user) {
      onSucess();
      notifyListeners();
    }).catchError((e) {
      onFail();
      notifyListeners();
    });
  }

  void editarUsuario({
    @required Map<String, dynamic> usuarioData,
    @required VoidCallback onSucess,
    @required VoidCallback onFail,
  }) {
    notifyListeners();

    _editarUsuario(usuarioData).then((user) {
      onSucess();

      notifyListeners();
    }).catchError((e) {
      onFail();

      notifyListeners();
    });
  }

  sair() async {
    await _auth.signOut();

    usuarioData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _savarUsuario(
      Map<String, dynamic> usuarioData, String firebaseUID) async {
    this.usuarioData = usuarioData;
    await Firestore.instance
        .collection('usuarios')
        .document(firebaseUID)
        .setData(usuarioData);
  }

  Future<Null> carregarUsuarios() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (usuarioData['nome'] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection('usuarios')
            .document(firebaseUser.uid)
            .get();

        usuarioData = docUser.data;
      }
      notifyListeners();
    }
  }

  Future<Null> _editarUsuario(Map<String, dynamic> usuarioData) async {
    this.usuarioData = usuarioData;
    await Firestore.instance
        .collection('usuarios')
        .document(firebaseUser.uid)
        .updateData(usuarioData);

    notifyListeners();
  }

  Future getImage() async {
    carregando = true;
    notifyListeners();
    File image;
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 40);

    imageFile = image;

    carregando = false;
    notifyListeners();
  }

  Future uploadImage() async {
    carregando = true;
    notifyListeners();
    StorageUploadTask uploadTask = reference.putFile(imageFile);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      //print('EVENT ${event.type}');
      porcentagem = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble();
      //print(_porcentagem);
      notifyListeners();
    });

    await uploadTask.onComplete;

    streamSubscription.cancel();

    var downloadUrl = await reference.getDownloadURL();

    carregando = false;
    notifyListeners();

    return downloadUrl;
  }

  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto) async {
    final message = Message()
      ..from = Address("pretainformatica.7cold.co@gmail.com",
          'Preta Celulares e Informática')
      ..recipients.add(destinatario)
      ..subject = assunto
      ..text = mensagem;

    try {
      final DocumentSnapshot doc =
          await Firestore.instance.document('configuracoes/email').get();

      final email = doc.data['email'] as String;
      final senha = doc.data['senha'] as String;

      final sendReport = await send(message, gmail(email, senha));
      print('Message sent: ' + sendReport.toString());

      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }

      return false;
    }
  }

  sendEmail(mensagem, destinatario, assunto) async {
    carregando = true;
    notifyListeners();
    bool result = await sendMessage(mensagem, destinatario, assunto);
    print(result);
    carregando = false;
    notifyListeners();
  }

  sendEmailVendedor(ordemId) async {
    carregando = true;
    notifyListeners();

    String nome = usuarioData['nome'];
    String email = usuarioData['email'];
    bool result = await sendMessage(
        "Cliente: $nome \nEmail: $email\nOrdemID: $ordemId",
        "pretainformatica.7cold.co@gmail.com",
        "Nova Venda!");
    print(result);
    carregando = false;
    notifyListeners();
  }
}
