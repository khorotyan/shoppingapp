class FirebaseLoginResult {
  String kind;
  String idToken;
  String email;
  String refreshToken;
  String expiresIn;
  String localId;

  FirebaseLoginResult(this.kind, this.idToken, this.email, this.refreshToken,
      this.expiresIn, this.localId);
}
