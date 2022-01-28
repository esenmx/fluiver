extension ListExtensions<E> on List<E> {
  /// Swaps the elements in the indices provided.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// list.swap(0, 2); // [3, 2, 1, 4]
  /// ```
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }
}
