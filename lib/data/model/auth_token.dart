class AuthToken {
  final String accountToken;
  final String userSessionToken;
  final String clientToken;

  const AuthToken({
    this.accountToken,
    this.userSessionToken,
    this.clientToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accountToken: json['account_token'],
      userSessionToken: json['user_session_token'],
      clientToken: json['client_token'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'account_token': accountToken,
        'user_session_token': userSessionToken,
        'client_token': clientToken
      };
}
