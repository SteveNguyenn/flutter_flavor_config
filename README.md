# Config Variables for your Flutter apps

Plugin that exposes environment variables to your Dart code in Flutter as well as to your native code in iOS and Android.

Inspired by [react-native-config](https://github.com/luggit/react-native-config)

## Basic Usage

Create a new file `.env` in the root of your Flutter app:

```
API_URL=https://myapi.com
FABRIC_ID=abcdefgh
```

load all environment varibles in `main.dart`

```dart
import 'package:flutter_flavor_config/flutter_flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterFlavorConfig
  await FlutterFlavorConfig.loadEnvVariables();

  runApp(MyApp());
}
```

Now you can access your environment varibles anywhere in your app.

```dart
import 'package:flutter_flavor_config/flutter_flavor_config.dart';

FlutterFlavorConfig.get('FABRIC_ID') // returns 'abcdefgh'
```

Keep in mind this module doesn't obfuscate or encrypt secrets for packaging, so **do not store sensitive keys in `.env`**. It's [basically impossible to prevent users from reverse engineering mobile app secrets](https://rammic.github.io/2015/07/28/hiding-secrets-in-android-apps/), so design your app (and APIs) with that in mind.

<br/>

### Load Environment Varibles in Swift

First import the plugin
```Swift
import flutter_flavor_config
```
Then you can use the .env Variable, replace `ENV_API_KEY` with yours.
```Swift
flutter_flavor_config.FlutterFlavorConfigPlugin.env(for: "ENV_API_KEY")
```


## Getting Started

Install the latest version of the plugin

Refer to [Android Setup Guide](./doc/ANDROID.md) for initial setup and advanced options

No additional setup is required for iOS, however, for advanced usage refer to the [iOS Setup Guide](./doc/IOS.md)

## Testing

Whenever you need to use `FlutterFlavorConfig` in your tests, simply use the method `loadValueForTesting`

```dart
import 'package:flutter_flavor_config/flutter_flavor_config.dart';

void main() {
  FlutterFlavorConfig.loadValueForTesting({'BASE_URL': 'https://www.mockurl.com'});
  
  test('mock http client test', () {
    final client = HttpClient(
      baseUrl: FlutterFlavorConfig.get('BASE_URL')
    );
  });
}
```
