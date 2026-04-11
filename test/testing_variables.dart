import 'package:flutter_flavor_config/flutter_flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FlutterFlavorConfig.loadValueForTesting({'BASE_URL': 'https://www.google.com'});

  test('test vairable should be available on test', () {
    final baseUrl = FlutterFlavorConfig.get('BASE_URL');

    expect(baseUrl, matches('https://www.google.com'));
  });
}
