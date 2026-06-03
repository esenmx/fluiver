part of '../../fluiver.dart';

/// {@macro extensionFor}
/// Kotlin-style `let` scope function on any non-null object.
///
/// Bounded to `T extends Object` so `.let` only appears on non-null
/// receivers. Use `?.let(...)` for null-aware chaining.
extension Let<T extends Object> on T {
  /// Applies [fn] to `this` and returns the result.
  ///
  /// Use it to pipe a value through a transform without naming a temp:
  ///
  /// ```dart
  /// // 1. Null-aware transform that returns a value
  /// final port = env['PORT']?.let(int.parse);
  /// final user = jsonResponse?.let(User.fromJson);
  ///
  /// // 2. Inline widget construction via tear-off
  /// Column(children: [
  ///   Text(title),
  ///   ?subtitle?.let(Text.new),
  ///   ?avatarUrl?.let(NetworkImage.new)?.let(_circle),
  /// ]);
  ///
  /// // 3. Chain pure transformations
  /// final hash = userId.toString().let(FastHash.fnv1a);
  ///
  /// // 4. Conditional spread of children
  /// Column(children: [
  ///   Text(title),
  ///   ...?subtitle?.let((s) => [const SizedBox(height: 4), Text(s)]),
  /// ]);
  ///
  /// // 5. Static method as a transform — no lambda needed
  /// final id = rawId?.let(int.tryParse);
  /// ```
  ///
  /// Anti-patterns: side-effect-only calls (`.let` returns a value — wasted
  /// if you ignore it); long bodies that hide intent (use a temp variable);
  /// chains longer than three (use named steps).
  R let<R>(R Function(T it) fn) => fn(this);
}
