import 'package:flutter/material.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/modelos/carrinho_modelos.dart';
import 'package:pretainformatica/modelos/pesquisa_produtos_modelos.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/index.dart';
import 'package:pretainformatica/telas/principal_tela.dart';
import 'package:pretainformatica/telas/teste_cep.dart';
import 'package:pretainformatica/widgets/sistema/splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UsuarioModelo>(
      model: UsuarioModelo(),
      child: ScopedModelDescendant<UsuarioModelo>(
          builder: (context, child, model) {
        return ScopedModel<CarrinhoModelo>(
          model: CarrinhoModelo(model),
          child: ScopedModelDescendant<CarrinhoModelo>(
            builder: (context, child, model) {
              return ScopedModel<PesquisaModelo>(
                model: PesquisaModelo(),
                child: ScopedModelDescendant<PesquisaModelo>(
                  builder: (context, child, model) {
                    return MaterialApp(
                      theme: ThemeData(
                        primarySwatch: primaria,
                      ),
                      debugShowCheckedModeBanner: false,
                      home: IndexScreen(),
                      //home: PrincipalTela(),
                      //home: TesteCep(),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
