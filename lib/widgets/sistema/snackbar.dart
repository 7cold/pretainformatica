import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final snackBarErroEmail = SnackBar(
  backgroundColor: CupertinoColors.systemRed,
  duration: Duration(seconds: 4),
  behavior: SnackBarBehavior.floating,
  content: Text("Ops! Email ou senha incorretos.."),
);

final snackBarErro = SnackBar(
  backgroundColor: CupertinoColors.systemRed,
  duration: Duration(seconds: 4),
  behavior: SnackBarBehavior.floating,
  content: Text("Ops! Algo deu errado.."),
);

final snackBarOk = SnackBar(
  backgroundColor: CupertinoColors.systemGreen,
  duration: Duration(seconds: 4),
  behavior: SnackBarBehavior.floating,
  content: Text("Sucesso!"),
);
