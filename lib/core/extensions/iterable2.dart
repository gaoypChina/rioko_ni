extension Iterable2<E> on Iterable<E> {
  E? reduceOrNull(E Function(E value, E element) combine) {
    if (isEmpty) return null;
    return reduce(combine);
  }
}
