import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String payment_response = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Paytm example app'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $payment_response\n'),
              RaisedButton(
                onPressed: () {
                  //Firstly Generate CheckSum bcoz Paytm Require this
                  generateCheckSum();
                },
                color: Colors.blue,
                child: Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void generateCheckSum() async {
    var url =
        'https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum';

    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    //Please use your parameters here
    //CHANNEL_ID etc provided to you by paytm

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

    //for Testing(Stagging) use this

    //https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=

    //https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=

    String callBackUrl =
        'https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=' +
            orderId;

    print("Response :" + response.body);

    //Parameters are like as per given below

    // Testing (Staging or Production) if true then Stagginh else Production
    // MID provided by paytm
    // ORDERID your system generated order id
    // CUSTOMER ID
    // CHANNEL_ID provided by paytm
    // AMOUNT
    // WEBSITE provided by paytm
    // CallbackURL (As used above)
    // INDUSTRY_TYPE_ID provided by paytm
    // checksum generated now

    //Testing Credentials
    //Mobile number: 7777777777
    //OTP: 489871

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
      setState(() {
        payment_response = value.toString();
      });
    });
  }
}
