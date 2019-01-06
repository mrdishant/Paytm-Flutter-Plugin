import 'dart:async';

import 'package:flutter/services.dart';

class Paytm {
  static const MethodChannel _channel = const MethodChannel('paytm');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map<dynamic, dynamic>> startPaytmPayment(
      bool testing,
      String mId,
      String orderId,
      String custId,
      String channelId,
      String txnAmount,
      String website,
      String callBackUrl,
      String industryTypeId,
      String checkSumHash) async {
    Map<dynamic, dynamic> response =
        await _channel.invokeMethod('startPaytmPayment', {
      "mId": mId,
      "testing": testing,
      'orderId': orderId,
      'custId': custId,
      'channelId': channelId,
      'txnAmount': txnAmount,
      'website': website,
      'callBackUrl': callBackUrl,
      'industryTypeId': industryTypeId,
      'checkSumHash': checkSumHash
    });

    return response;
  }
}
