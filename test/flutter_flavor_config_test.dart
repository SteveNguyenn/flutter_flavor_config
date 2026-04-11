import 'package:flutter/services.dart';
import 'package:flutter_flavor_config/flutter_flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_flavor_config');
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return {'FABRIC': 67};
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('get variable', () async {
    await FlutterFlavorConfig.loadEnvVariables();
    expect(FlutterFlavorConfig.get('FABRIC'), 67);
  });
}
