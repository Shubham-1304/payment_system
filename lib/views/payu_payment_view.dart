import 'package:flutter/material.dart';
import 'package:payment_system/views/api.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'dart:convert';

class PayuPaymentView extends StatefulWidget {
  const PayuPaymentView({Key? key}) : super(key: key);

  @override
  State<PayuPaymentView> createState() => _PayuPaymentViewState();
}

class _PayuPaymentViewState extends State<PayuPaymentView>
    implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;
  //final temp = ConnectionMaking().requestApiIntegration();
  final hostedIntegreation = ConnectionMaking().hostedRequestApiIntegration();

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  Widget build(BuildContext context) {
    print(hostedIntegreation);
    return Center(
      child: ElevatedButton(
        child: const Text("Start Payment"),
        onPressed: () async {
          await _checkoutPro.openCheckoutScreen(
            payUPaymentParams: PayUParams.createPayUPaymentParams(),
            payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
          );
        },
      ),
    );
    // MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('PayU Checkout Pro'),
    //     ),
    //     body: Center(
    //       child: ElevatedButton(
    //         child: const Text("Start Payment"),
    //         onPressed: () async {
    //           _checkoutPro.openCheckoutScreen(
    //             payUPaymentParams: PayUParams.createPayUPaymentParams(),
    //             payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  generateHash(Map response) {
    // Pass response param to your backend server
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server

    var hashName = response[PayUHashConstantsKeys.hashName];
    var hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
    var hashType = response[PayUHashConstantsKeys.hashType];
    var postSalt = response[PayUHashConstantsKeys.postSalt];
    // var hash = <Get Hash Backend with < hashString, merchantSalt , postSalt >
    var hash = generateHash(hashName + postSalt);
    // Call hashGenerated with HashResponse< hashName , Hash>
    Map hashResponse = {};
    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) {
//Handle Success response
  }

  @override
  onPaymentFailure(dynamic response) {
//Handle Failure response
  }

  @override
  onPaymentCancel(Map? response) {
//Handle Payment cancel response
  }

  @override
  onError(Map? response) {
//Handle on error response
  }
}

class PayUTestCredentials {
  //Find the test credentials from dev guide: https://devguide.payu.in/flutter-sdk-integration/getting-started-flutter-sdk/mobile-sdk-test-environment/
  static const merchantKey = "3TnMpV"; // Add you Merchant Key
  static const iosSurl = "<ADD YOUR iOS SURL>";
  static const iosFurl = "<ADD YOUR iOS FURL>";
  static const androidSurl = "<ADD YOUR ANDROID SURL>";
  static const androidFurl = "<ADD YOUR ANDROID FURL>";

  static const merchantAccessKey = ""; //Add Merchant Access Key - Optional
  static const sodexoSourceId = ""; //Add sodexo Source Id - Optional
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
  static Map createPayUPaymentParams() {
    var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1', //Required
      PayUSIParamsKeys.billingInterval: '1', //Required
      PayUSIParamsKeys.paymentStartDate: '2023-04-20', //Required
      PayUSIParamsKeys.paymentEndDate: '2023-04-30', //Required
      PayUSIParamsKeys.billingCycle: //Required
          'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
      PayUAdditionalParamKeys.merchantAccessKey:
          PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };

    var spitPaymentDetails = {
      "type": "absolute",
      "splitInfo": {
        PayUTestCredentials.merchantKey: {
          "aggregatorSubTxnId":
              "1234567540099887766650091", //unique for each transaction
          "aggregatorSubAmt": "1"
        }
      }
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey,
      PayUPaymentParamKey.amount: "1",
      PayUPaymentParamKey.productInfo: "Info",
      PayUPaymentParamKey.firstName: "Abc",
      PayUPaymentParamKey.email: "test@gmail.com",
      PayUPaymentParamKey.phone: "9999999999",
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
      PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential:
          null, //Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId: DateTime.fromMicrosecondsSinceEpoch
          .toString(), //DateTime.now().millisecondsSinceEpoch.toString()
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: true,
      PayUPaymentParamKey.splitPaymentDetails: json.encode(spitPaymentDetails),
      PayUPaymentParamKey.userToken:
          "", //Pass a unique token to fetch offers. - Optional
    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}
