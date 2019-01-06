import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    generateCheckSum();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Paytm.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  void generateCheckSum() async {
    var url =
        'https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum';

    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await http.post(url, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "mid": "ParloS79006455919746",
      "CHANNEL_ID": "WAP",
      'INDUSTRY_TYPE_ID': 'Retail',
      'WEBSITE': 'APPSTAGING',
      'PAYTM_MERCHANT_KEY': '380W#7mf&_SpEgsy',
      'TXN_AMOUNT': '10',
      'ORDER_ID': orderId,
      'CUST_ID': '122',
    });

    String callBackUrl =
        'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=' +
            orderId;

    print("Response :" + response.body);

    var paytmResponse = Paytm.startPaytmPayment(
        true,
        "ParloS79006455919746",
        orderId,
        "122",
        "WAP",
        "10",
        'APPSTAGING',
        callBackUrl,
        'Retail',
        response.body);

    paytmResponse.then((value) {
      print(value.toString());
    });
  }
}
