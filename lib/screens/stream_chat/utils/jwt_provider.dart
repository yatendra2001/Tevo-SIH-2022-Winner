import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:tevo/keys/key.dart';

class JwtProvider {
  static Future<String> tokenProvider(String id) async {
    final jwt = JWT(
      {'user_id': id},
    );
    var token =
        jwt.sign(SecretKey(streamChatSecretKey), algorithm: JWTAlgorithm.HS256);
    return token;
  }
}
