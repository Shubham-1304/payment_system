import 'package:crypto/crypto.dart';
import 'dart:convert';

String getHashes({
  required String txnId,
  required String amount,
  required String productInfo,
  required String firstName,
  required String email,
  // required String user_credential,
  String udf1 = "",
  String udf2 = "",
  String udf3 = "",
  String udf4 = "",
  String udf5 = "",
  // required String offerKey,
  // required String cardBin,
}) {
  var key = "C0Dr8m";
  var salt = "3sf0jURk";
  var payhash_str =
      "$key|$txnId|$amount|$productInfo|$firstName|$email|$udf1|$udf2|$udf3|$udf4|$udf5||||||$salt";
  var paymentHash = _getSHA(payhash_str);

  print("PAYMENT HASH $paymentHash");
  return paymentHash;
}

String _getSHA(String ph) {
  String out = "";
  try {
    print("ph $ph");
    // var bytes = utf8.encode(ph);
    // var digest = sha512.convert(bytes);
    // var mb=digest.bytes;
    var bytes = utf8.encode(ph); // convert string to UTF-8 encoded bytes
    var digest = sha512.convert(bytes); // compute SHA-512 hash digest
    var mb = digest.bytes;
    // var mb = digest.toString();
    for (int i = 0; i < mb.length; i++) {
      int temp = mb[i];
      String s = temp.toRadixString(16);
      while (s.length < 2) {
        s = "0" + s;
      }
      s = s.substring(s.length - 2);
      out += s;
    }
  } catch (e) {
    print("error");
    print(e);
  }
  return out;
}
