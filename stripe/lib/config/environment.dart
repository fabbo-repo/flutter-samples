import 'package:envied/envied.dart';

part 'environment.g.dart';

// This class contains all the environment variables
@Envied(path: 'app.env', requireEnvFile: true)
abstract class Environment {
  @EnviedField(varName: "STRIPE_PUB_KEY")
  static const String stripePubKey = _Environment.stripePubKey;
}
