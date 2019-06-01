# paytm

A Flutter plugin to use the Paytm as a gateway for accepting online paymnets in Flutter app. 

## Getting Started

![Screenshot_20190601-141441](https://user-images.githubusercontent.com/25786428/58746334-d66f3680-847a-11e9-85b0-804d42207f12.jpg)![Screenshot_20190601-141450](https://user-images.githubusercontent.com/25786428/58746336-d707cd00-847a-11e9-80ce-4e7814a43ddb.jpg)![Screenshot_20190601-141512](https://user-images.githubusercontent.com/25786428/58746340-e555e900-847a-11e9-8796-1df156751652.jpg)

### Testing Credentials:
MID : ParloS79006455919746
CHANNEL_ID: WAP
INDUSTRY_TYPE_ID: Retail
WEBSITE: APPSTAGING
PAYTM_MERCHANT_KEY: 380W#7mf&_SpEgsy

Lets’s begin

You can start paytm transaction following two steps:

#### 1.Generate CheckSum:

You have to setup CheckSum Generation on your server ideally. But for testing purpose you can use the below api and request it and it will provide you checksum for your transaction.

CheckSum Generation URL: https://us-central1-mrdishant-4819c.cloudfunctions.net/generateCheckSum

Parameters to be passed: (Using flutter http package)


```
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
```


Replace the values with merchant account your values , and in response you will get checksum.

var checksum = response.body;

#### 2. Start Payment:

Callback Url:

For Testing(Stagging) use this:
https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=

For Production(Stagging) use this:
https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=

```
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
```



For Cloning the example app code visit:
[Paytm Plugin](https://github.com/mrdishant/Paytm-Flutter-Plugin)

For detailed usage visit :
[Paytm Plugin](https://medium.com/@mr.dishantmahajan/paytm-plugin-flutter-paytm-4aa144da4fd4)

For any query :
Mail me at mr.dishantmahajan@gmail.com