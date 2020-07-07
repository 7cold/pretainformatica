import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';

class BotaoPrincipal extends StatelessWidget {
  final String label;
  final double minWidth;
  final Function function;

  const BotaoPrincipal({
    @required this.label,
    @required this.minWidth,
    @required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: function, //since this is only a UI app
      child: Text(
        label,
        style: fontBold16White,
      ),
      color: Color(corAccent),
      highlightColor: Color(corPrincipal).withOpacity(0.4),
      splashColor: Colors.transparent,
      disabledElevation: 0,
      highlightElevation: 0,
      elevation: 0,
      minWidth: minWidth,
      height: 50,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class BotaoSecundario extends StatelessWidget {
  final String label;
  final double minWidth;
  final Function function;

  const BotaoSecundario({
    @required this.label,
    @required this.minWidth,
    @required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: function, //since this is only a UI app
      child: Text(
        label,
        style: fontBold16White,
      ),
      color: Color(corDark),
      highlightColor: Color(corPrincipal).withOpacity(0.4),
      splashColor: Colors.transparent,
      disabledElevation: 0,
      highlightElevation: 0,
      elevation: 0,
      minWidth: minWidth,
      height: 50,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
