class EntityPage<T> {
  final List<T> list;
  final int total;

  const EntityPage({
    required this.list,
    required this.total,
  });
}
