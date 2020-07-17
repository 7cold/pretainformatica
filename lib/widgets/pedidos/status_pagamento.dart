import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pretainformatica/configs/fontes.dart';

class StatusPagamento extends StatefulWidget {
  final String payId;

  const StatusPagamento({Key key, this.payId}) : super(key: key);
  @override
  _StatusPagamentoState createState() => _StatusPagamentoState(payId);
}

class _StatusPagamentoState extends State<StatusPagamento> {
  final String payId;

  String _statusPay = "";
  String _typePay = "";
  String _typeFlag = "";
  String _cpfPayer = "";
  String _namePayer = "";
  String _last4 = "";
  String _dateApproved = "000000000000000000000000000000";
  String _dateExp = "000000000000000000000000000000";
  List _refunds = [];
  String _dateRefunds = "000000000000000000000000000000";
  bool _carregando = true;

  _StatusPagamentoState(this.payId);

  initialMP() async {
    String url = "https://api.mercadopago.com/v1/payments/" +
        payId +
        "?access_token=APP_USR-182247360055120-070317-0220c139f0f957d71c368b902a4ca441-602690240";
    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> res = jsonDecode(response.body);

    if (this.mounted) {
      setState(() {
        _statusPay = res['status'];
        _typePay = res['payment_type_id'];
        _typeFlag = res['payment_method_id'];
        _dateApproved = res['date_approved'];
        _refunds = res['refunds'];

        if (_typePay == "ticket") {
          _dateExp = res['date_of_expiration'];
        } else {
          _cpfPayer = res['card']['cardholder']['identification']['number'];
          _namePayer = res['card']['cardholder']['name'];
          _last4 = res['card']['last_four_digits'];
        }

        _refunds.forEach((result) {
          _dateRefunds = result['date_created'];
        });

        _carregando = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initialMP();

    _dateApproved == null
        ? _dateApproved = "000000000000000000000000000000"
        : _dateApproved;

    String formatDiaExp = _dateExp.substring(8, 10);
    String formatMesExp = _dateExp.substring(5, 7);
    String formatAnoExp = _dateExp.substring(0, 4);
    int formatHoraExp = int.parse(_dateExp.substring(11, 13));
    String formatMinExp = _dateExp.substring(14, 16);
    int formatHoraNewExp = formatHoraExp + 1;

    String formatDia = _dateApproved.substring(8, 10);
    String formatMes = _dateApproved.substring(5, 7);
    String formatAno = _dateApproved.substring(0, 4);
    int formatHora = int.parse(_dateApproved.substring(11, 13));
    String formatMin = _dateApproved.substring(14, 16);
    int formatHoraNew = formatHora + 1;

    String formatDiaRef = _dateRefunds.substring(8, 10);
    String formatMesRef = _dateRefunds.substring(5, 7);
    String formatAnoRef = _dateRefunds.substring(0, 4);
    int formatHoraRef = int.parse(_dateRefunds.substring(11, 13));
    String formatMinRef = _dateRefunds.substring(14, 16);
    int formatHoraNewRef = formatHoraRef + 1;

    return Container(
      height: 350,
      child: Center(
        child: _carregando == true
            ? CupertinoActivityIndicator()
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Status",
                        style: fontHeavy18Grey,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          Text(
                            "Pagamento: ",
                            style: fontBold16Dark,
                          ),
                          _buildStatus(_statusPay),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          Text(
                            "ID: ",
                            style: fontBold16Dark,
                          ),
                          Text(
                            payId,
                            style: fontLight16Grey,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text(
                            "Tipo: ",
                            style: fontBold16Dark,
                          ),
                          _buildType(_typePay),
                        ],
                      ),
                      SizedBox(height: 10),
                      _typePay == "ticket"
                          ? Column(
                              //BOLETO
                              children: [
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Data de Expiração: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildDateRefunds(formatDiaExp +
                                        "/" +
                                        formatMesExp +
                                        "/" +
                                        formatAnoExp +
                                        "-" +
                                        formatHoraNewExp.toString() +
                                        ":" +
                                        formatMinExp),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          : Column(
                              //CARTAO
                              children: [
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Bandeira: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildFlag(_typeFlag),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "CPF Pagador: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildCpfPayer(_cpfPayer),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Nome Cartão: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildNamePayer(_namePayer),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Últimos 4 dig.: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildLast4(_last4),
                                  ],
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                      _statusPay == "rejected"
                          ? SizedBox()
                          : Row(
                              children: <Widget>[
                                Text(
                                  "Aprovado em: ",
                                  style: fontBold16Dark,
                                ),
                                _buildDateApproved(formatDia +
                                    "/" +
                                    formatMes +
                                    "/" +
                                    formatAno +
                                    "-" +
                                    formatHoraNew.toString() +
                                    ":" +
                                    formatMin),
                              ],
                            ),
                      SizedBox(height: 10),
                      _statusPay == "rejected"
                          ? SizedBox()
                          : _statusPay == "refunded"
                              ? Row(
                                  children: <Widget>[
                                    Text(
                                      "Devolvido em: ",
                                      style: fontBold16Dark,
                                    ),
                                    _buildDateRefunds(formatDiaRef +
                                        "/" +
                                        formatMesRef +
                                        "/" +
                                        formatAnoRef +
                                        "-" +
                                        formatHoraNewRef.toString() +
                                        ":" +
                                        formatMinRef),
                                  ],
                                )
                              : SizedBox()
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _buildDateRefunds(String dateRefunds) {
    return Text(
      dateRefunds,
      style: fontLight16Grey,
    );
  }

  _buildDateApproved(String dateApproved) {
    return Text(
      dateApproved,
      style: fontLight16Grey,
    );
  }

  _buildDateExp(String _dateExp) {
    return Text(
      _dateExp,
      style: fontLight16Grey,
    );
  }

  _buildLast4(String last4) {
    return Text(
      last4,
      style: fontLight16Grey,
    );
  }

  _buildNamePayer(String namePayer) {
    return Text(
      namePayer,
      style: fontLight16Grey,
    );
  }

  _buildCpfPayer(String cpfPayer) {
    return Text(
      cpfPayer,
      style: fontLight16Grey,
    );
  }

  _buildFlag(String typeFlag) {
    return Text(
      typeFlag == "visa"
          ? "Visa"
          : typeFlag == "master"
              ? "Master"
              : typeFlag == "elo" ? "Elo" : "Outro",
      style: fontLight16Grey,
    );
  }

  _buildType(String typePay) {
    return Text(
      typePay == "credit_card"
          ? "Cartão de Crédito"
          : typePay == "debit_card"
              ? "Cartão de Débito"
              : typePay == "ticket" ? "Boleto" : "Outro",
      style: fontLight16Grey,
    );
  }

  _buildStatus(String statusPay) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color:
              statusPay == "refunded"
                  ? CupertinoColors.systemRed
                  : statusPay == "rejected"
                      ? CupertinoColors.systemRed
                      : statusPay == "cancelled"
                          ? CupertinoColors.systemRed
                          : statusPay == "pending"
                              ? CupertinoColors.systemYellow
                              : statusPay == "in_process"
                                  ? CupertinoColors.systemYellow
                                  : statusPay == "authorized"
                                      ? CupertinoColors.systemBlue
                                      : statusPay == "approved"
                                          ? CupertinoColors.systemGreen
                                          : statusPay == "partially_refunded"
                                              ? CupertinoColors.systemRed
                                              : statusPay == "charged_back"
                                                  ? CupertinoColors.systemRed
                                                  : statusPay == "vacated"
                                                      ? CupertinoColors
                                                          .systemRed
                                                      : statusPay ==
                                                              "Payment not found"
                                                          ? CupertinoColors
                                                              .systemYellow
                                                          : statusPay ==
                                                                  "Not Found"
                                                              ? CupertinoColors
                                                                  .systemYellow
                                                              : "",
          borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(
          statusPay == "refunded"
              ? "Devolvido"
              : statusPay == "rejected"
                  ? "Rejeitado"
                  : statusPay == "cancelled"
                      ? "Cancelado"
                      : statusPay == "pending"
                          ? "Pendente"
                          : statusPay == "in_process"
                              ? "Em Processo"
                              : statusPay == "authorized"
                                  ? "Autorizado"
                                  : statusPay == "approved"
                                      ? "Aprovado"
                                      : statusPay == "partially_refunded"
                                          ? "Parcialmente Retornado"
                                          : statusPay == "charged_back"
                                              ? "Parcialmente Estornado"
                                              : statusPay == "vacated"
                                                  ? "Erro Inesperado"
                                                  : statusPay ==
                                                          "Payment not found"
                                                      ? "Não Pago"
                                                      : statusPay == "Not Found"
                                                          ? "Não Encontrado"
                                                          : "",
          style: fontBold14White,
        ),
      ),
    );
  }
}
