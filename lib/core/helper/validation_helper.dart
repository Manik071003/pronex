class ValidationHelper {
  static final RegExp _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final RegExp _mobileRegex = RegExp(r'(^[1-9a-zA-Z])');

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]+(?:\s[a-zA-Z]+)+(?:\s[a-zA-Z]+)?$',
  );

  static String? validateEmailAddress(String? email) {
    final hasMatched = _emailRegex.hasMatch(email ?? '');
    if (!hasMatched) {
      return 'Please enter a valid Email ID';
    } else {
      return null;
    }
  }

  static String? validateName(String? name) {
    final hasMatched = _nameRegExp.hasMatch(name ?? '');
    if (!hasMatched) {
      return 'Please enter a valid Name';
    } else {
      return null;
    }
  }

  static bool validatePassword(String value) {
    RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    if (value.isEmpty) {
      return true;
    } else {
      if (!regex.hasMatch(value)) {
        return true;
      } else {
        return false;
      }
    }
  }

  static String? validateMobile(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Please Enter Mobile Number';
    }
    // else if (input.trim().length < 10) {
    //   return 'At least 10 digits required';
    // }
    else {
      return null;
    }
  }

  static String? validateOTP(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Please enter OTP';
    } else if (input.trim().length < 6) {
      return 'Please enter a valid OTP';
    } else if (!_mobileRegex.hasMatch(input)) {
      return 'Invalid OTP Number';
    } else {
      return null;
    }
  }

  static String? validatePIN(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Please enter PIN';
    } else if (input.trim().length < 4) {
      return 'At least 4 digits required';
    } else if (!_mobileRegex.hasMatch(input)) {
      return 'Invalid PIN';
    } else {
      return null;
    }
  }

  static String? validateEmpty(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Please enter detail';
    } else {
      return null;
    }
  }
}
