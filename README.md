# paytm

A Flutter plugin to use the Paytm as a gateway for accepting online paymnets in Flutter app. 

## Getting Started

![Screenshot_20190601-141441(1)](https://user-images.githubusercontent.com/25786428/58746425-ad9b7100-847b-11e9-97bd-6d820fb6d03c.jpg)

![Screenshot_20190601-141450(1)](https://user-images.githubusercontent.com/25786428/58746429-b12ef800-847b-11e9-9ab1-2622a7312838.jpg)

![Screenshot_20190601-141512](https://user-images.githubusercontent.com/25786428/58746430-b4c27f00-847b-11e9-88e6-6b1ea4d2b7c1.jpg)


### Testing Credentials:
MID : ParloS79006455919746

CHANNEL_ID: WAP

INDUSTRY_TYPE_ID: Retail

WEBSITE: APPSTAGING

PAYTM_MERCHANT_KEY: 380W#7mf&_SpEgsy

### Lets’s begin

You can start paytm transaction following two steps:

#### 1. Generate CheckSum:

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

Parameters are like as per given below

1.Testing (Staging or Production) if true then Stagging else Production

2.MID provided by paytm

3.ORDERID your system generated order id

4.CUSTOMER ID

5.CHANNEL_ID provided by paytm

6.AMOUNT

7.WEBSITE provided by paytm

8.CallbackURL (As discussed above)

9.INDUSTRY_TYPE_ID provided by paytm

10.checksum generated now

For Cloning the example app code visit:
[Paytm Plugin](https://github.com/mrdishant/Paytm-Flutter-Plugin)

For detailed usage visit :
[Paytm Medium Post](https://medium.com/@mr.dishantmahajan/paytm-plugin-flutter-paytm-4aa144da4fd4)

For any query :
Mail me at mr.dishantmahajan@gmail.com