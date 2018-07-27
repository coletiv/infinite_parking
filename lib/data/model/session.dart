class Session {
  final String accountToken;
  final String userSessionToken;
  final String clientToken;

  const Session({this.accountToken, this.userSessionToken, this.clientToken});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
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
