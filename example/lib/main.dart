import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htkc_razorpay/model/upi_account.dart';
import 'package:htkc_razorpay/htkc_razorpay.dart';
import 'package:htkc_razorpay/model/razorpay_error.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  // TPV Key - rzp_test_5sHeuuremkiApj
  //Non-TPV key - rzp_test_0wFRWIZnH65uny
  //Checkout key - rzp_live_ILgsfZCZoFIKMb
  String merchantKeyValue = "rzp_live_ILgsfZCZoFIKMb";
  String amountValue = "100";
  String orderIdValue = "";
  String mobileNumberValue = "8888888888";

  late HCRazorpay razorpay ;

  @override
  void initState() {
    razorpay = HCRazorpay("rzp_test_qRGYYA5wZrpFvJ").initUpiTurbo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomEditText(
              controller: keyController,
              textInputType: TextInputType.text,
              hintText: 'Enter Key',
              labelText: 'Merchant Key',
            ),
            CustomEditText(
              controller: amountController,
              textInputType: TextInputType.number,
              hintText: 'Enter Amount',
              labelText: 'Amount',
            ),
            CustomEditText(
              controller: orderIdController,
              textInputType: TextInputType.text,
              hintText: 'Enter Order Id',
              labelText: 'Order Id',
            ),
            CustomEditText(
              controller: mobileNumberController,
              textInputType: TextInputType.number,
              hintText: 'Enter Mobile Number',
              labelText: 'Mobile Number',
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
              child: const Text(
                '* Note - In case of TPV the orderId is mandatory.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomButton(
                    widthSize: 200.0,
                    onPressed: () {
                      merchantKeyValue = keyController.text;
                      amountValue = amountController.text;

                      razorpay.on(HCRazorpay.eventPaymentError, handlePaymentErrorResponse);
                      razorpay.on(HCRazorpay.eventPaymentSuccess, handlePaymentSuccessResponse);
                      razorpay.on(HCRazorpay.eventExternalWallet, handleExternalWalletSelected);
                      razorpay.open(getPaymentOptions());
                    },
                    labelText: 'Standard Checkout Pay',
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    widthSize: 200.0,
                    onPressed: () {
                      merchantKeyValue = keyController.text;
                      amountValue = amountController.text;
                      mobileNumberValue = mobileNumberController.text;
                      orderIdValue = orderIdController.text;

                      razorpay.on(HCRazorpay.eventPaymentError, handlePaymentErrorResponse);
                      razorpay.on(HCRazorpay.eventPaymentSuccess, handlePaymentSuccessResponse);
                      razorpay.on(HCRazorpay.eventExternalWallet, handleExternalWalletSelected);
                      razorpay.open(getTurboPaymentOptions());
                    },
                    labelText: 'Turbo Pay',
                  ),
                ),
              ],
            ),
            CustomEditText(
              controller: mobileNumberController,
              textInputType: TextInputType.number,
              hintText: 'Enter Mobile Number',
              labelText: 'Mobile Number',
            ),
            CustomButton(
              widthSize: 200.0,
              labelText: "Link New Upi Account",
              onPressed: () {
                mobileNumberValue = mobileNumberController.text;

                razorpay.upiTurbo.linkNewUpiAccount(customerMobile: mobileNumberValue,
                    color: "#ffffff",
                    onSuccess: (List<UpiAccount> upiAccounts) {
                      if (kDebugMode) {
                        print("Successfully Onboarded Account : ${upiAccounts.length}");
                      }
                    },
                    onFailure:(RazorpayError error) { ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error : ${error.errorDescription}")));}
                );
              },
            ),
            CustomButton(
              widthSize: 200.0,
              labelText: "Manage Upi Account",
              onPressed: () {
                mobileNumberValue = mobileNumberController.text;

                razorpay.upiTurbo.manageUpiAccounts(customerMobile: mobileNumberValue,
                    color: "#ffffff",
                    onFailure:(RazorpayError error) { ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error : ${error.errorDescription}")));}
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Object> getPaymentOptions() {
    return {
      'key': merchantKeyValue,
      'amount': int.parse(amountValue),
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': mobileNumberValue,
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };
  }

  Map<String, Object> getTurboPaymentOptions() {
    return {
      'amount': int.parse(amountValue),
      'currency': 'INR',
      'prefill':{
        'contact':mobileNumberValue,
        'email':'test@razorpay.com'
      },
      'theme':{
        'color':'#0CA72F'
      },
      'send_sms_hash':true,
      'retry':{
        'enabled':false,
        'max_count':4
      },
      'key': merchantKeyValue,
      'order_id':orderIdValue,
      'disable_redesign_v15': false,
      'experiments.upi_turbo':true,
      'ep':'https://api-web-turbo-upi.ext.dev.razorpay.in/test/checkout.html?branch=feat/turbo/tpv'
    };
  }


  //Handle Payment Responses

  void handlePaymentErrorResponse(PaymentFailureResponse response){

    /** PaymentFailureResponse contains three values:
     * 1. Error Code
     * 2. Error Description
     * 3. Metadata
     **/
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){

    /** Payment Success Response contains three values:
     * 1. Order ID
     * 2. Payment ID
     * 3. Signature
     **/
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  String labelText;
  VoidCallback onPressed;
  double widthSize = 100.0;

  CustomButton({super.key, required this.widthSize,
        required this.labelText,
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthSize,
      height: 50.0,
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 12.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
        ),
        child: Text(
          labelText,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomEditText extends StatelessWidget {
  String hintText;
  String labelText;
  TextInputType textInputType;
  TextEditingController controller;

  CustomEditText(
      {super.key, required this.textInputType,
        required this.hintText,
        required this.labelText,
        required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}
