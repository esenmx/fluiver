part of fluiver;

/// Reference: https://stackoverflow.com/a/49648870/10380182
Future<bool> hasConnection() async {
  return InternetAddress.lookup('example.com')
      .then((value) => value.isNotEmpty && value[0].rawAddress.isNotEmpty)
      .catchError((error) => false);
}
