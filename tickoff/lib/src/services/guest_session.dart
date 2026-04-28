class GuestSession {
  GuestSession._();

  static bool _isGuest = false;

  static bool get isGuest => _isGuest;

  static void startGuestSession() {
    _isGuest = true;
  }

  static void endGuestSession() {
    _isGuest = false;
  }
}
