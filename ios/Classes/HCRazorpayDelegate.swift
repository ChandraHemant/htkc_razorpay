import Flutter
import HCRazorpay

public class HCRazorpayDelegate: NSObject, HCRazorpayPaymentCompletionProtocolWithData, ExternalWalletSelectionProtocol {
    
    static let CODE_PAYMENT_SUCCESS = 0
    static let CODE_PAYMENT_ERROR = 1
    static let CODE_PAYMENT_EXTERNAL_WALLET = 2
    
    static let NETWORK_ERROR = 0
    static let INVALID_OPTIONS = 1
    static let PAYMENT_CANCELLED = 2
    static let TLS_ERROR = 3
    static let INCOMPATIBLE_PLUGIN = 3
    static let UNKNOWN_ERROR = 100
    
    public func onExternalWalletSelected(_ walletName: String, withPaymentData paymentData: [AnyHashable : Any]?) {
        var response = [String:Any]()
        response["type"] = HCRazorpayDelegate.CODE_PAYMENT_EXTERNAL_WALLET
        
        var data = [String:Any]()
        data["external_wallet"] = walletName
        response["data"] = data
        
        pendingResult(response as NSDictionary)
    }
    
    private var pendingResult: FlutterResult!
    
    public func onPaymentError(_ code: Int32, description message: String, andData data: [AnyHashable : Any]?) {
        var response = [String:Any]()
        response["type"] = HCRazorpayDelegate.CODE_PAYMENT_ERROR
        
        var errorData = [String:Any]()
        errorData["code"] = HCRazorpayDelegate.translateRzpPaymentError(errorCode: Int(code))
        errorData["message"] = message 
        errorData["responseBody"] = data
        
        response["data"] = errorData
        pendingResult(response as NSDictionary)
    }
    
    public func onPaymentSuccess(_ payment_id: String, andData data: [AnyHashable: Any]?) {
        var response = [String:Any]()
        response["type"] = HCRazorpayDelegate.CODE_PAYMENT_SUCCESS
        response["data"] = data
        
        pendingResult(response as NSDictionary)
    }
    
    public func open(options: Dictionary<String, Any>, result: @escaping FlutterResult) {
        
        self.pendingResult = result
        
        let key = options["key"] as? String
        
        let razorpay = HCRazorpayCheckout.initWithKey(key ?? "", andDelegateWithData: self)
        razorpay.setExternalWalletSelectionDelegate(self)
        var options = options
        options["integration"] = "flutter"
        options["FRAMEWORK"] = "flutter"
        razorpay.open(options)
    }
    
    public func resync(result: @escaping FlutterResult) {
        result(nil)
    }
    
    static func translateRazorpayPaymentError(errorCode: Int) -> Int {
        switch (errorCode) {
        case 0:
            return NETWORK_ERROR
        case 1:
            return INVALID_OPTIONS
        case 2:
            return PAYMENT_CANCELLED
        default:
            return UNKNOWN_ERROR
        }
    }
    
}
