import 'common_utils.dart';

bool validateEmail(String? value) {
  if (value == null || value.isEmpty) return false;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern.toString());
  return regex.hasMatch(value);
}

bool validatePassword(String password) {
  return password.isNotEmpty && password.length >= 6;
}

bool validatePhone(String value) {
  if (value.isEmpty) return false;
  Pattern pattern = r'^(0[0-9]{9})$';
  RegExp regex = new RegExp(pattern.toString());
  return regex.hasMatch(value);
}

bool validateComment(String value) {
  return value.isNotEmpty && value.length < 1001 && value.trim().length > 0;
}

bool validateLoMoId(String value) {
  if (value.isEmpty) return false;
  Pattern pattern = r'^[a-z0-9]{6,30}$';
  RegExp regex = new RegExp(pattern.toString());
  print(value);
  print(regex.hasMatch(value));
  return regex.hasMatch(value);
}

bool validateUserName(String value) {
  if (value.isEmpty) return false;
  Pattern pattern = r'^[a-zA-Z0-9\s]{6,30}$';
  RegExp regex = new RegExp(pattern.toString());
  return regex.hasMatch(convertVietnamToEnglish(value));
}

bool validateDisplayName(String value) {
  return value.isNotEmpty && value.length < 31 && value.trim().length > 5;
}

bool validateLength(String value) {
  return value.isNotEmpty && value.length > 0;
}
