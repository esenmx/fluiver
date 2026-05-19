part of '../../fluiver.dart';

/// Dispatches to the callback matching the current platform.
///
/// ```dart
/// final padding = platformDispatch<EdgeInsets>(
///   android: () => const .all(8),
///   ios: () => const .all(16),
///   web: () => .zero,
/// );
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
