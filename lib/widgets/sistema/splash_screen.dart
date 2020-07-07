import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/telas/index.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IndexScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(corDark),
      body: Stack(
        children: <Widget>[
          FlareActor(
            "assets/animacoes/pretainformatica_background.flr",
            animation: "animacao",
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/logo/logo.png",
              scale: 4,
            ),
          )
        ],
      ),
    );
  }
}
