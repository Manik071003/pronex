// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pronex/core/constants/shared_prefs_constants.dart';
import 'package:pronex/core/helper/shared_pref_helper.dart';
import 'package:pronex/core/models/created_investment_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses payment account details from settings payload', () {
    final data = {
      'success': true,
      'settings': {
        'id': 'abc123',
        'accountName': 'PronexWorld',
        'accountNumber': '12345666',
        'ifscCode': '12334DFS0121',
        'bankName': 'Union India',
        'upiId': 'mahima.babani@gmail.com',
        'qrCode': 'https://example.com/qr.jpg',
      },
    };

    final investment = CreatedInvestment.fromJson(data);

    expect(investment.accountName, 'PronexWorld');
    expect(investment.accountNumber, '12345666');
    expect(investment.ifsc, '12334DFS0121');
    expect(investment.bankName, 'Union India');
    expect(investment.upiId, 'mahima.babani@gmail.com');
    expect(investment.qrCodeUrl, 'https://example.com/qr.jpg');
  });

  test('stores persisted login session data', () async {
    SharedPreferences.setMockInitialValues({});

    await SharedPrefHelper.setBool(SharedPrefs.isLoggedIn, true);
    await SharedPrefHelper.setString(SharedPrefs.token, 'test-token');

    expect(await SharedPrefHelper.getBool(SharedPrefs.isLoggedIn), isTrue);
    expect(await SharedPrefHelper.getString(SharedPrefs.token), 'test-token');
  });
}
