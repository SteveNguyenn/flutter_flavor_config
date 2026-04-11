import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Flutter flavor config writes environment variables to `BuildConfig` for
/// Android and as a `NSDictionary` for iOS.
class FlutterFlavorConfig {
  /// An instance of all environment variables
  late Map<String, dynamic> _variables;

  // Private Constructor
  FlutterFlavorConfig._internal();

  // Instance of FlutterFlavorConfig
  static final FlutterFlavorConfig _instance = FlutterFlavorConfig._internal();

  static const MethodChannel _channel =
      MethodChannel('flutter_flavor_config');

  /// Variables need to be loaded on app startup, recommend to do it `main.dart`
  static loadEnvVariables() async {
    final Map<String, dynamic>? loadedVariables =
        await _channel.invokeMapMethod('loadEnvVariables');
    _instance._variables = loadedVariables ?? {};
  }

  /// Returns a specific variable value give a [key]
  static dynamic get(String key) {
    var variables = _instance._variables;

    if (variables.isEmpty) {
      print(
        'FlutterFlavorConfig variables are empty\n'
        'Ensure you have a .env file and you\n'
        'have loaded the variables',
      );
    } else if (variables.containsKey(key)) {
      return variables[key];
    } else {
      print(
        'FlutterFlavorConfig value for key($key) not found\n'
        'Ensure you have it in .env file',
      );
    }
  }

  /// returns all the current loaded variables;
  static Map<String, dynamic> get variables =>
      Map<String, dynamic>.of(_instance._variables);

  @visibleForTesting
  static loadValueForTesting(Map<String, dynamic> values) {
    _instance._variables = values;
  }
}
