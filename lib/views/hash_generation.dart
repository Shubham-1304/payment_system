import 'dart:convert';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:crypto/crypto.dart';

class HashGenerator {
  final String _key = "gtKFFx"; //put your merchant key value
  final String _salt = "eCwWELxi"; //put your merchant salt value
  final String _PAYMENT_HASH = "payment_hash";
  final String _GET_MERCHANT_IBIBO_CODES_HASH = "get_merchant_ibibo_codes_hash";
  final String _VAS_FOR_MOBILE_SDK_HASH = "vas_for_mobile_sdk_hash";
  final String _PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK_HASH =
      "payment_related_details_for_mobile_sdk_hash";
  final String _DELETE_USER_CARD_HASH = "delete_user_card_hash";
  final String _GET_USER_CARDS_HASH = "get_user_cards_hash";
  final String _EDIT_USER_CARD_HASH = "edit_user_card_hash";
  final String _SAVE_USER_CARD_HASH = "save_user_card_hash";
  final String _CHECK_OFFER_STATUS_HASH = "check_offer_status_hash";
  final String _CHECK_ISDOMESTIC_HASH = "check_isDomestic_hash";
  final String _VERIFY_PAYMENT_HASH = "verify_payment_hash";

  // void staticHash(){
  //   Map<String, Object> additionalParams = Map<String,Object>();
  //   additionalParams[PayUCheckoutProConstants.CP_VAS_FOR_MOBILE_SDK] = <String>;
  //   additionalParams[PayUCheckoutProConstants.CP_PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK] = <String>;
  // }

  String getHashes(
      String txnid,
      String amount,
      String productInfo,
      String firstname,
      String email,
      String user_credentials,
      String udf1,
      String udf2,
      String udf3,
      String udf4,
      String udf5) {
    var response;

    String ph = checkNull(_key) +
        "|" +
        checkNull(txnid) +
        "|" +
        checkNull(amount) +
        "|" +
        checkNull(productInfo) +
        "|" +
        checkNull(firstname) +
        "|" +
        checkNull(email) +
        "|" +
        checkNull(udf1) +
        "|" +
        checkNull(udf2) +
        "|" +
        checkNull(udf3) +
        "|" +
        checkNull(udf4) +
        "|" +
        checkNull(udf5) +
        "||||||" +
        _salt;

    String paymentHash = getSHA(ph); // 512
    //print("Payment Hash " + paymentHash);
    response[_PAYMENT_HASH] = paymentHash;
    response[_VAS_FOR_MOBILE_SDK_HASH] =
        generateHashString("vas_for_mobile_sdk", "default");

    //Use var1 as user_credentials if user_credential is not empty
    if (!checkNull(user_credentials).isEmpty) {
      response[_PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK_HASH] =
          generateHashString(
              "payment_related_details_for_mobile_sdk", user_credentials);

      response[_DELETE_USER_CARD_HASH] =
          generateHashString("delete_user_card", user_credentials);
      response[_GET_USER_CARDS_HASH] =
          generateHashString("get_user_cards", user_credentials);
      response[_EDIT_USER_CARD_HASH] =
          generateHashString("edit_user_card", user_credentials);
      response[_SAVE_USER_CARD_HASH] =
          generateHashString("save_user_card", user_credentials);
    } else {
      response[_PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK_HASH] =
          generateHashString(
              "payment_related_details_for_mobile_sdk", "default");
    }
    // print("Vas_for _mobile_sdk  " +
    //     generateHashString("vas_for_mobile_sdk", "default"));
    // print("payment_related_details_sdk_hash  " +
    //     generateHashString(
    //         "payment_related_details_for_mobile_sdk", user_credentials));

    // print("delete_user_card Hash" +
    //     generateHashString("delete_user_card", user_credentials));

    response = jsonEncode(response);

    return response.toString();
  }

  String generateHashString(String command, String var1) {
    return getSHA(_key + "|" + command + "|" + var1 + "|" + _salt);
  }

  String checkNull(String value) {
    if (value.isEmpty) {
      return "";
    } else {
      return value;
    }
  }

  String getSHA(String str) {
    String out = "";
    try {
      var bytes = utf8.encode(str);
      var digest = sha512.convert(bytes);
      var mb = digest.bytes;

      for (int i = 0; i < mb.length; i++) {
        var temp = mb[i];

        //String s = Integer.toHexString(new Byte(temp));
        String s = temp.toRadixString(16);
        while (s.length < 2) {
          s = "0" + s;
        }
        s = s.substring(s.length - 2);
        out += s;
      }
    } catch (e) {
      print(e);
    }

    return out;
  }
}
