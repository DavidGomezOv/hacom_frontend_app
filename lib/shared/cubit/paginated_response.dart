class PaginatedResponse<T> {
  final List<T> items;
  final int totalPages;

  PaginatedResponse({required this.items, required this.totalPages});
}
