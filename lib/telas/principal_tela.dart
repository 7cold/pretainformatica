import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretainformatica/configs/cores.dart';
import 'package:pretainformatica/configs/fontes.dart';
import 'package:pretainformatica/datas/produtos_data.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:pretainformatica/telas/pesquisa_tela.dart';
import 'package:pretainformatica/telas/produtos_detalhes.dart';
import 'package:pretainformatica/widgets/sistema/appBar.dart';
import 'package:pretainformatica/widgets/sistema/nav_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'categorias_cel_tela.dart';
import 'categorias_info_tela.dart';

class PrincipalTela extends StatefulWidget {
  @override
  _PrincipalTelaState createState() => _PrincipalTelaState();
}

class _PrincipalTelaState extends State<PrincipalTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(corPrincipal),
      appBar: appBar(context, "Home", true),
      body: ScopedModelDescendant<UsuarioModelo>(
        builder: (context, child, model) {
          String nomeSplit = model.usuarioData['nome'].toString();
          List nomeLista = nomeSplit.split(" ");
          String nomeFormatado = nomeLista[0];

          return model.usuarioData['nome'] == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Banners
                      FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection('banners')
                              .where('ativo', isEqualTo: true)
                              .getDocuments(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CupertinoActivityIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: Carousel(
                                        borderRadius: true,
                                        boxFit: BoxFit.cover,
                                        autoplay: false,
                                        autoplayDuration: Duration(seconds: 8),
                                        animationCurve:
                                            Curves.fastLinearToSlowEaseIn,
                                        dotSize: 4.0,
                                        dotIncreasedColor: Colors.transparent,
                                        dotBgColor: Colors.transparent,
                                        dotPosition: DotPosition.topRight,
                                        dotVerticalPadding: 0.0,
                                        showIndicator: true,
                                        indicatorBgPadding: 6.0,
                                        images:
                                            snapshot.data.documents.map((doc) {
                                          return FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image: doc.data['imagem'],
                                            fit: BoxFit.cover,
                                          );
                                        }).toList())),
                              );
                            }
                          }),

                      //Boas Vindas
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 20),
                        child: Text(
                          DateTime.now().hour > 4 && DateTime.now().hour < 12
                              ? "Bom dia "
                              : DateTime.now().hour >= 12 &&
                                      DateTime.now().hour < 18
                                  ? "Boa Tarde "
                                  : DateTime.now().hour >= 18 &&
                                          DateTime.now().hour <= 24
                                      ? "Boa Noite "
                                      : DateTime.now().hour >= 0 &&
                                              DateTime.now().hour <= 4
                                          ? "Boa Madrugada "
                                          : "",
                          style: fontBold18Grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          nomeFormatado,
                          style: fontHeavy24Dark,
                        ),
                      ),

                      //Buscar
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(FadeRoute(page: PesquisaTela()));
                          },
                          child: Hero(
                            tag: "pesquisar",
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(8),
                              shadowColor: Color(corCinza).withAlpha(60),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(corCinza).withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Pesquisar",
                                        style: fontBold14Grey,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.search,
                                        color: Color(corDark),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //Setores
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Setores",
                              style: fontHeavy24Dark,
                            ),
                            SizedBox(height: 10),
                            Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: ItemCategoriaGeral(
                                    nome: "Informática",
                                    imagem: "assets/icones/iso_pc.png",
                                    tela: CategoriasInfoTela(),
                                    color: Color.fromARGB(254, 162, 245, 255),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Flexible(
                                  flex: 1,
                                  child: ItemCategoriaGeral(
                                    nome: "Celulares",
                                    imagem: "assets/icones/iso_cel.png",
                                    tela: CategoriasCelTela(),
                                    color: Color.fromARGB(254, 220, 220, 255),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Principais
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "Destaques",
                              style: fontHeavy24Dark,
                            ),
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<QuerySnapshot>(
                            future: Firestore.instance
                                .collection("destaques")
                                .getDocuments(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              } else {
                                return Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    child: Row(
                                      children:
                                          snapshot.data.documents.map((doc) {
                                        return CustomCardSugestoes(doc: doc);
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class ItemCategoriaGeral extends StatelessWidget {
  final String nome;
  final String imagem;
  final Widget tela;
  final Color color;

  const ItemCategoriaGeral(
      {Key key, this.nome, this.imagem, this.tela, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => tela));
      },
      child: Material(
        elevation: 8,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        shadowColor: Color(corCinza).withAlpha(60),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  height: 150,
                  child: Image.asset(imagem),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(nome,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w800,
                        color: Color(corDark).withAlpha(220),
                        fontSize: w < 350 ? 16 : 20,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardSugestoes extends StatelessWidget {
  final DocumentSnapshot doc;

  CustomCardSugestoes({this.doc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(doc['setor'])
          .document(doc['categoria'])
          .collection('itens')
          .document(doc['idProduto'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new CupertinoActivityIndicator();
          default:
            ProdutoData data = ProdutoData.fromDocument(snapshot.data);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: ProdutosDetalhes(
                        data, doc['categoria'], snapshot.data['quantidade_e']),
                  ),
                );
              },
              child: Hero(
                tag: snapshot.data['imagem'],
                child: Material(
                  color: Colors.transparent,
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 10, 50),
                    height: 140,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data['imagem']),
                          fit: BoxFit.contain),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(corCinza).withAlpha(90),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                            ),
                            height: 30,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  snapshot.data['titulo'],
                                  style: fontBold14WhiteS,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
