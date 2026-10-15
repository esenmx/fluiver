/// Pipes any non-null object through a function: Kotlin's `let`, named so
/// it doesn't clash with other packages' `.let` extensions.
///
/// Bounded to `T extends Object` so `.into` only appears on non-null
/// receivers. Use `?.into(...)` for null-aware chaining.
///
/// Extension types are only subtypes of `Object?` unless they say otherwise,
/// so declare `implements Object` (or a non-null supertype) to get `.into`:
///
/// ```dart
/// extension type UserId(int value) implements Object;
///
/// final key = UserId(7).into((id) => 'user:${id.value}');
/// ```
extension ObjectInto<T extends Object> on T {
  /// Applies [fn] to `this` and returns the result.
  ///
  /// Use it to pipe a value through a transform without naming a temp:
  ///
  /// ```dart
  /// // 1. Null-aware transform that returns a value
  /// final port = env['PORT']?.into(int.parse);
  /// final user = jsonResponse?.into(User.fromJson);
  ///
  /// // 2. Inline widget construction via tear-off
  /// Column(children: [
  ///   Text(title),
  ///   ?subtitle?.into(Text.new),
  ///   ?avatarUrl?.into(NetworkImage.new).into(_circle),
  /// ]);
  ///
  /// // 3. Chain pure transformations
  /// final hash = userId.toString().into(FastHash.fnv1a);
  ///
  /// // 4. Conditional spread of children
  /// Column(children: [
  ///   Text(title),
  ///   ...?subtitle?.into((s) => [const SizedBox(height: 4), Text(s)]),
  /// ]);
  ///
  /// // 5. Static method as a transform — no lambda needed
  /// final id = rawId?.into(int.tryParse);
  /// ```
  ///
  /// Anti-patterns: side-effect-only calls (`.into` returns a value — wasted
  /// if you ignore it); long bodies that hide intent (use a temp variable);
  /// chains longer than three (use named steps).
  R into<R>(R Function(T it) fn) => fn(this);
}
