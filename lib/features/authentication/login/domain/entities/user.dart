class User {
  final String message;
  final String phone;
  final String name;
  final String id;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final int refreshExpiresIn;

  User({
    required this.message,
    required this.phone,
    required this.name,
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
  });
}
