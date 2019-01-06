import Flutter
import UIKit
import PaymentSDK

public class SwiftPaytmPlugin: NSObject, FlutterPlugin,PGTransactionDelegate {
    
    private var flutterResult:FlutterResult?

    private var paytmTransapaytmTransactionController: PGTransactionViewController? = PGTransactionViewController.init(transactionParameters: ["":""])

    private var aObjNavi: UINavigationController?

    public func didFinishedResponse(_ controller: PGTransactionViewController, response responseString: String) {
        
        
        var paramMap = [String: Any]()
        

        let paytmStatus = "STATUS"
    let paytmChecksumHash = "CHECKSUMHASH"
    let paytmBankName = "BANKNAME"
    let paytmOrderId = "ORDERID"
    let paytmTransactionAmount = "TXNAMOUNT"
    let paytmTransactionDate = "TXNDATE"
    let paytmMerchantId = "MID"
    let paytmTransactionId = "TXNID"
    let paytmResponseCode = "RESPCODE"
    let paytmPaymentMode = "PAYMENTMODE"
    let paytmBankTransactionId = "BANKTXNID"
    let paytmCurrency = "CURRENCY"
    let paytmGatewayName = "GATEWAYNAME"
let paytmResponseMessage = "RESPMSG"

        if let data = responseString.data(using: String.Encoding.utf8) {
            do {
                if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:String] , jsonresponse.count > 0{
                    paramMap[paytmStatus] = jsonresponse[paytmStatus] ?? ""
                    paramMap[paytmChecksumHash] = jsonresponse[paytmChecksumHash] ?? ""
                    paramMap[paytmBankName] = jsonresponse[paytmBankName] ?? ""
                    paramMap[paytmOrderId] = jsonresponse[paytmOrderId] ?? ""
                    paramMap[paytmTransactionAmount] = jsonresponse[paytmTransactionAmount] ?? ""
                    paramMap[paytmTransactionDate] = jsonresponse[paytmTransactionDate] ?? ""
                    paramMap[paytmTransactionId] = jsonresponse[paytmTransactionId] ?? ""
                    paramMap[paytmMerchantId] = jsonresponse[paytmMerchantId] ?? ""
                    paramMap[paytmResponseCode] = jsonresponse[paytmResponseCode] ?? ""
                    paramMap[paytmPaymentMode] = jsonresponse[paytmPaymentMode] ?? ""
                    paramMap[paytmBankTransactionId] = jsonresponse[paytmBankTransactionId] ?? ""
                    paramMap[paytmCurrency] = jsonresponse[paytmCurrency] ?? ""
                    paramMap[paytmGatewayName] = jsonresponse[paytmGatewayName] ?? ""
                    paramMap[paytmResponseMessage] = jsonresponse[paytmResponseMessage] ?? ""
                    controller.navigationController?.popViewController(animated: true)
                    self.flutterResult!(paramMap)
                }
            } catch {
                controller.navigationController?.popViewController(animated: true)
                 paramMap["error"]=true
        paramMap["errorMessage"]="Error"
    
        self.flutterResult!(paramMap)
        
            }
        }
        
        
            
        print("response is ",responseString)

    }

    public func didCancelTrasaction(_ controller: PGTransactionViewController) {
        
        controller.navigationController?.popViewController(animated: true)
        var paramMap = [String: Any]()
        
        paramMap["error"]=true
        paramMap["errorMessage"]="Cancelled"
    
        self.flutterResult!(paramMap)
        
//        self.paytmTransapaytmTransactionController!.dismiss(animated: true, completion: nil)
        print("Cancelled")
    }

    public func errorMisssingParameter(_ controller: PGTransactionViewController, error: NSError?) {
        controller.navigationController?.popViewController(animated: true)
        var paramMap = [String: Any]()
        
        paramMap["error"]=true
        paramMap["errorMessage"]=(error!.localizedDescription)
        
        self.flutterResult!(paramMap)
        print(error)
    }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paytm", binaryMessenger: registrar.messenger())
    let instance = SwiftPaytmPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    
    flutterResult=result

    let arguements = call.arguments as? NSDictionary
    
    if(call.method.elementsEqual("startPaytmPayment")){
     
        let mId = arguements!["mId"] as! String

        
        print(mId);
        beginPayment(arguements: arguements!)

    }

    
  }

func beginPayment(arguements :NSDictionary) {

    let type :ServerType
    let order = PGOrder(orderID: "", customerID: "", amount: "", eMail: "", mobile: "")
    
    let mId = arguements["mId"] as! String
    let testing = arguements["testing"] as! Bool
    let ORDER_ID = arguements["orderId"] as! String
    let custId = arguements["custId"] as! String
    let channelId = arguements["channelId"] as! String
    let txnAmount = arguements["txnAmount"] as! String
    let website = arguements["website"] as! String
    
    let callBackUrl = arguements["callBackUrl"] as! String
    let industryTypeId = arguements["industryTypeId"] as! String
    let checkSumHash = arguements["checkSumHash"] as! String
    
    if (testing){
       type = .eServerTypeStaging
    }else{
       type = .eServerTypeProduction
    }

    order.params = ["MID": mId,
        "ORDER_ID": ORDER_ID,
        "CUST_ID": custId,
        "CHANNEL_ID": channelId,
        "WEBSITE": website,
        "TXN_AMOUNT": txnAmount,
        "INDUSTRY_TYPE_ID": industryTypeId,
        "CHECKSUMHASH": checkSumHash,
        "CALLBACK_URL": callBackUrl]

    self.paytmTransapaytmTransactionController =  self.paytmTransapaytmTransactionController!.initTransaction(for: order) as?PGTransactionViewController
    self.paytmTransapaytmTransactionController!.title = "Paytm Payments"
    self.paytmTransapaytmTransactionController!.setLoggingEnabled(true)
    if(type != ServerType.eServerTypeNone) {
        self.paytmTransapaytmTransactionController!.serverType = type;
    } else {
        return
    }
    self.paytmTransapaytmTransactionController!.merchant = PGMerchantConfiguration.defaultConfiguration()
    self.paytmTransapaytmTransactionController!.delegate = self

    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.pushViewController(self.paytmTransapaytmTransactionController!, animated: true)
        }
        
        let storyboard : UIStoryboard? = UIStoryboard.init(name: "Main", bundle: nil)
        let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!

        let objVC: UIViewController? = storyboard!.instantiateViewController(withIdentifier: "FlutterViewController")
        self.aObjNavi = UINavigationController(rootViewController: objVC!)
        window.rootViewController = self.aObjNavi!
self.aObjNavi!.pushViewController(self.paytmTransapaytmTransactionController!, animated: true)
}
    
  
}
