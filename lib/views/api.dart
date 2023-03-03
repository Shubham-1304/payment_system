import 'package:http/http.dart' as http;

class ConnectionMaking {
  Future<bool> requestApiIntegration() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'key': 'l1K8X1P1',
      'command': 'l1K8X1P1',
      'var1': '7fa6c4783a363b3da573',
      'hash':
          'c24ee06c7cf40314ede424b1fcc2b97a12f97a7d3dd206876eef16660eb09fd374fd82861f66d8152e72d1c9e3ee37fc691d47d6a387502872b03c7338a50880',
    };

    var body =
        "key=${data['key']}g&command=${data['command']}&var1=${data['var1']}&var4=&var5=&var6=&var7=&var8=&var9=&hash=${data['hash']}";

    var url = Uri.parse('https://test.payu.in/merchant/postservice?form=2-H');
    var res = await http.post(url, headers: headers, body: body);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    print(res.body);
    return true;
  }

  Future<bool> hostedRequestApiIntegration() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var data = {
      'key': 'l1K8X1P1',
      'txnid': 'txnid110132896480',
      'amount': '10.00',
      'firstname': 'PayU User',
      'productinfo': 'iPhone',
      'email': 'test@gmail.com',
      'phone': '9876543210',
      'surl': 'https://apiplayground-response.herokuapp.com/',
      'furl': 'https://apiplayground-response.herokuapp.com/',
      'hash':
          'fa4fb8347c6417d8fc3c4d8abab40248a21ff72a4f46af14a011a87098859a22d171ba92fac5eeebf508730d8ed9cad84e02079ac011ec7e76f5dbd7ae13221f',
    };

    var body =
        'key=${data['key']}&txnid=${data['txnid']}&amount=${data['amount']}&firstname=${data['firstname']}&email=${data['email']}&phone=${data['phone']}&productinfo=${data['productinfo']}&pg=&bankcode=&surl=${data['surl']}&furl=${data['furl']}&hash=${data['hash']}';

    var url = Uri.parse('https://test.payu.in/_payment-H');
    var res = await http.post(url, headers: headers, body: body);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    print(res.body);

    return true;
  }
}
