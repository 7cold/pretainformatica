import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:pretainformatica/datas/carrinho_data.dart';
import 'package:pretainformatica/datas/cep_data.dart';
import 'package:pretainformatica/modelos/usuarios_modelos.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModelo extends Model {
  UsuarioModelo user;
  List<CarrinhoProdutos> products = [];
  var mp = MP("182247360055120", "E2Z9pSFGsFhNux9cP24RovdhL4QCuW16");
  var resultRefIdMP;

  Future<Map<String, dynamic>> preferenceGetMP() async {
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    var preference = {
      "items": [
        {
          "title": "Produtos Preta Info&Cel",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": productsPrice - discount + shipPrice
        }
      ],
      "payer": {
        "email": user.firebaseUser.email,
        "name": user.firebaseUser.uid
      },
      "payment_methods": {
        "excluded_payment_types": [
          {"id": "atm"},
        ]
      },
    };

    resultRefIdMP = await mp.createPreference(preference);
    //print(resultRefIdMP);

    isLoading = false;
    notifyListeners();

    return resultRefIdMP;
  }

  String couponCode;
  String shipping = "irei_buscar";
  double precoEntrega = 0;
  int discountPercentage = 0;

  bool isLoading = false;
  bool carregandoEntrega = false;

  CarrinhoModelo(this.user) {
    if (user.verifLogado() == true) _loadCartItems();
  }

  static CarrinhoModelo of(BuildContext context) =>
      ScopedModel.of<CarrinhoModelo>(context);

  Future<CepAberto> getEndereco(String cep) async {
    carregandoEntrega = true;
    notifyListeners();
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Token token=7c53ade91840f51cf1f35256c49ded9c';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        carregandoEntrega = false;
        notifyListeners();
        return Future.error('CEP Inválido');
      }

      final CepAberto address = CepAberto.fromMap(response.data);
      carregandoEntrega = false;
      notifyListeners();

      return address;
    } on DioError catch (e) {
      carregandoEntrega = false;
      notifyListeners();
      return Future.error(e);
    }
  }

  calcularEntrega(double lat, double long) async {
    carregandoEntrega = true;
    notifyListeners();

    final DocumentSnapshot doc =
        await Firestore.instance.document('configuracoes/entrega').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final maxKm = doc.data['max_km'] as num;
    final precoKm = doc.data['preco_km'] as num;
    final precoBase = doc.data['preco_base'] as num;
    final freteGratis = doc.data['frete_gratis'] as num;
    final freteGratisKm = doc.data['frete_gratis_km'] as num;

    double dis =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);
    dis /= 1000;

    precoEntrega = precoBase + dis * precoKm;
    if (dis > maxKm) {
      carregandoEntrega = false;
      notifyListeners();
      return "endereco com km nao entregue";
    } else {
      carregandoEntrega = false;
      notifyListeners();
      print(getProductsPrice());
      return getProductsPrice() > freteGratis || dis < freteGratisKm
          ? setShippingPrice(0.0)
          : setShippingPrice(precoEntrega);
    }
  }

  void addCartItem(CarrinhoProdutos cartProduct, int qtdEstoque) {
    products.add(cartProduct);

    Firestore.instance
        .collection('usuarios')
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });
    notifyListeners();

    decEstoque(cartProduct, qtdEstoque);

    notifyListeners();
  }

  void removeCartItem(CarrinhoProdutos cartProduct) {
    Firestore.instance
        .collection('usuarios')
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CarrinhoProdutos cartProduct) {
    cartProduct.quantidade--;

    Firestore.instance
        .collection('usuarios')
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void pararPedido(String id) {
    Firestore.instance
        .collection("ordens")
        .document(id)
        .updateData({"status": 0});

    notifyListeners();
  }

  decEstoque(CarrinhoProdutos cartProduct, int qtdEstoque) async {
    print(qtdEstoque);
    await Firestore.instance
        .collection(cartProduct.setor)
        .document(cartProduct.categoria)
        .collection("itens")
        .document(cartProduct.pid)
        .updateData({
      'quantidade_e': qtdEstoque - 1,
    });
    notifyListeners();
  }

  incEstoque(CarrinhoProdutos cartProduct, int qtdEstoque) async {
    print(qtdEstoque);
    await Firestore.instance
        .collection(cartProduct.setor)
        .document(cartProduct.categoria)
        .collection("itens")
        .document(cartProduct.pid)
        .updateData({
      'quantidade_e': qtdEstoque + 1,
    });
    notifyListeners();
  }

  incQuandoRemovido(CarrinhoProdutos cartProduct, int qtdEstoque) async {
    print(qtdEstoque);
    await Firestore.instance
        .collection(cartProduct.setor)
        .document(cartProduct.categoria)
        .collection("itens")
        .document(cartProduct.pid)
        .updateData({
      'quantidade_e': qtdEstoque + cartProduct.quantidade,
    });
    notifyListeners();
  }

  void incProduct(CarrinhoProdutos cartProduct) {
    cartProduct.quantidade++;
    Firestore.instance
        .collection('usuarios')
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
    notifyListeners();
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CarrinhoProdutos c in products) {
      if (c.productData != null)
        price += c.quantidade * c.productData.precoPromocao;
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  void setShippingPrice(double precoEntrega) {
    this.precoEntrega = precoEntrega;
    notifyListeners();
  }

  double getShipPrice() {
    return precoEntrega;
  }

  void setShipping(String shipping) {
    this.shipping = shipping;
    notifyListeners();
  }

  String getShipping() {
    return shipping;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    String shipping = getShipping();
    double precoEntrega = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await Firestore.instance.collection("ordens").add({
      "usuarioId": user.firebaseUser.uid,
      "usuario_nome": user.usuarioData['nome'],
      "produtos": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "preco_entrega": precoEntrega,
      "data": Timestamp.now(),
      "produtos_preco": productsPrice,
      "desconto": discount,
      "entrega": shipping,
      "preco_total": productsPrice - discount + precoEntrega,
      "status": 1,
      "refIdMP": resultRefIdMP['response']['id'],
      "payInfo": {'id': "00000"}
    });

    await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("ordens")
        .document(refOrder.documentID)
        .setData({
      "orderId": refOrder.documentID,
      "data": Timestamp.now(),
    });

    QuerySnapshot query = await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    shipping = "";
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("usuarios")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    products = query.documents
        .map((doc) => CarrinhoProdutos.fromDocument(doc))
        .toList();

    notifyListeners();
  }

  Future createPayInfo(orderID, payId) async {
    isLoading = true;
    notifyListeners();

    await Firestore.instance.collection("ordens").document(orderID).updateData({
      "payInfo": {
        'id': payId.toString(),
      }
    });
    isLoading = false;
    notifyListeners();
  }
}
