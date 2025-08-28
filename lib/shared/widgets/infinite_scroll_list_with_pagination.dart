import 'package:flutter/material.dart';

class InfiniteScrollListWithPagination<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final VoidCallback onFetchMore;
  final bool isFetching;
  final bool canFetchMore;
  final double scrollOffset;

  const InfiniteScrollListWithPagination({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onFetchMore,
    required this.isFetching,
    required this.canFetchMore,
    this.scrollOffset = 200,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!isFetching &&
            canFetchMore &&
            scrollInfo.metrics.pixels >=
                (scrollInfo.metrics.maxScrollExtent - scrollOffset)) {
          onFetchMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: items.length + (canFetchMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, items[index]);
        },
      ),
    );
  }
}
