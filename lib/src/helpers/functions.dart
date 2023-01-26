part of fluiver;

/// Checks whether device has connection to internet or not
/// Reference: https://stackoverflow.com/a/49648870/10380182
Future<bool> deviceHasConnection() async {
  return InternetAddress.lookup('example.com')
      .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
      .catchError((error) => false);
}
