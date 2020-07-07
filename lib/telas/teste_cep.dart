import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';

class TesteCep extends StatefulWidget {
  @override
  _TesteCepState createState() => _TesteCepState();
}

var mp = MP("182247360055120", "E2Z9pSFGsFhNux9cP24RovdhL4QCuW16");
var resultRefIdMP;

Future<Map<String, dynamic>> preferenceGetMP() async {
  var preference = {
    "items": [
      {
        "title": "Produtos Preta Info&Cel",
        "quantity": 1,
        "currency_id": "BRL",
        "unit_price": 1
      }
    ],
    "payer": {
      "email": "test_user_123456@testuser.com",
    },
  };

  resultRefIdMP = await mp.createPreference(preference);
  debugPrint(resultRefIdMP.toString());

  return resultRefIdMP;
}

class _TesteCepState extends State<TesteCep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              preferenceGetMP();
            },
            child: Text("data"),
          ),
        ),
      ),
    );
  }
}
