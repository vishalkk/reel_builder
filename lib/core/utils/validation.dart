class Validation {
  bool _isMin8Symbols = false;
  bool _isMin2BigLetters = false;
  bool _isMin1SpecialSign = false;
  bool _passwordMatch = false;

  bool get isMin8Symbols => _isMin8Symbols;
  bool get isMin2BigLetters => _isMin2BigLetters;
  bool get isMin1SpecialSign => _isMin1SpecialSign;
  bool get passwordMatch => _passwordMatch;

  bool get formValid {
    if (_isMin8Symbols && _isMin2BigLetters & _isMin1SpecialSign) {
      return true;
    }
    return false;
  }

  void validatePassword(String password) {
    if (password.length > 7) {
      _isMin8Symbols = true;
    } else {
      _isMin8Symbols = false;
    }

    if (password.contains(RegExp(r'^(.*?[A-Z]){2,}'))) {
      _isMin2BigLetters = true;
    } else {
      _isMin2BigLetters = false;
    }

    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _isMin1SpecialSign = true;
    } else {
      _isMin1SpecialSign = false;
    }
  }

  void passwordsMatch(String password, String confirmPassword) {
    if (password == confirmPassword) {
      _passwordMatch = true;
    } else {
      _passwordMatch = false;
    }
  }
}
