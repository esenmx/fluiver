part of '../../fluiver.dart';

/// Dispatches to the callback matching the current platform.
///
/// ```dart
/// final storeUrl = platformDispatch<Uri>(
///   android: () {
///     return Uri.parse('https://play.google.com/store/apps/details?id=com.example.app');
///   },
///   ios: () {
///     return Uri.parse('https://apps.apple.com/app/id123456789');
///   },
/// );
/// await launchUrl(storeUrl);
/// ```
///
/// Throws [UnsupportedError] if the current platform has no callback —
/// callers opt in to the platforms they support.
T platformDispatch<T>({
  T Function()? android,
  T Function()? fuchsia,
  T Function()? ios,
  T Function()? linux,
  T Function()? macOS,
  T Function()? windows,
  T Function()? web,
}) {
  final T Function()? callback;
  if (kIsWeb) {
    callback = web;
  } else {
    callback = switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.fuchsia => fuchsia,
      TargetPlatform.iOS => ios,
      TargetPlatform.linux => linux,
      TargetPlatform.macOS => macOS,
      TargetPlatform.windows => windows,
    };
  }

  if (callback != null) {
    return callback();
  }

  throw UnsupportedError(kIsWeb ? 'web' : defaultTargetPlatform.name);
}
