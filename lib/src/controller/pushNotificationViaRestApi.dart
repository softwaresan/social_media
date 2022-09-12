import 'dart:convert';

import 'package:http/http.dart' as http;

class pushNotification {
  Future<bool> callOnFcmApiSendPushNotifications(
      {required String title, required String body, required token}) async {
    print(token);

    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to":
          "cs0h1cE3SWOVo-feel7arX:APA91bHTn3S4WvDJGlO9w9a4zOXF-zE_dN2b1Vml8kEbk5Dgz25AuM94wzWCoPTqOK0OZFI0f6bGGDOZbK31wmlnJa4WeYEKjVxJwfQvioFeDnvPJNrg-TPUVuX4NzIKB0UjlHqcfc5L",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA5veRxBs:APA91bET1Y9PyZBJVCDnvcRTOy9jnCFRADho4zEtodOzrahCyqIJQEeC9uJv0zJFNSqy2vzMKBOjS289C5cqGsiDC2heL6qasKljFY-giurGRx9LQfJZYjJDGyumK47Z9z8ooDREJHyp'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
