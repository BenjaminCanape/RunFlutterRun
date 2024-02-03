class PageResponse<T> {
  final List<T> list;
  final int total;

  const PageResponse({
    required this.list,
    required this.total,
  });

  factory PageResponse.fromMap(Map<String, dynamic> map) {
    return PageResponse(list: map['content'], total: map['totalElements']);
  }
}
