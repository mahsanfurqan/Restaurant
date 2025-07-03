import 'package:jwt_decoder/jwt_decoder.dart';

class TokenManager {
  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
    // try {
    // } catch (e) {
    //   debugPrint('Error: $e');
    //   return true;
    // }
  }

  Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }
}
