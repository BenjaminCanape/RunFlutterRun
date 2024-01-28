import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/debouncer.dart';
import '../../../../domain/entities/page.dart';
import '../utils/color_utils.dart';
import '../utils/ui_utils.dart';
import 'view_model/infinite_scroll_list_view_model.dart';
import 'view_model/state/infinite_scroll_list_state.dart';

typedef LoadDataFunction<T> = Future<EntityPage<dynamic>> Function(
    int pageNumber);

class InfiniteScrollList extends HookConsumerWidget {
  final String listId;
  final List<dynamic> initialData;
  final int total;
  final LoadDataFunction<dynamic> loadData;
  final Widget Function(BuildContext context, List<dynamic> list, int item)
      itemBuildFunction;
  final bool Function(List<dynamic> data, int total) hasMoreData;
  final debouncer = Debouncer(milliseconds: 1000);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  InfiniteScrollList(
      {super.key,
      required this.listId,
      required this.initialData,
      required this.total,
      required this.loadData,
      required this.itemBuildFunction,
      required this.hasMoreData});

  Future<void> loadMoreData(InfiniteScrollListState state,
      InfiniteScrollListViewModel provider) async {
    double newPos = scrollController.position.pixels;
    var editData = false;
    if (!state.isLoading && hasMoreData(state.data, total)) {
      provider.setIsLoading(true);
      editData = true;

      try {
        final newData = await loadData(state.pageNumber);

        if (state.data is List<List<dynamic>>) {
          provider.setData(
            newData.list,
            newPos,
          );
        } else {
          provider.addData(newData.list, newPos);
        }
      } finally {
        provider.setIsLoading(false);

        if (editData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(newPos);
          });
        }
      }
    }
  }

  Widget buildLoadingIndicator() {
    return Center(child: UIUtils.loader);
  }

  Widget buildLoadMoreButton(BuildContext context,
      InfiniteScrollListState state, InfiniteScrollListViewModel provider) {
    return InkWell(
      onTap: () => loadMoreData(state, provider),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.load_more,
            style: TextStyle(
              color: ColorUtils.main,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(infiniteScrollListViewModelProvider(listId));
    final provider =
        ref.watch(infiniteScrollListViewModelProvider(listId).notifier);

    scrollController.addListener(() => debouncer.run(() {
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent &&
              !state.isLoading & hasMoreData(state.data, total)) {
            loadMoreData(state, provider);
          }
        }));

    Future.delayed(const Duration(milliseconds: 10), () {
      state.data.isNotEmpty ? '' : provider.setData(initialData, 0);
    });

    return state.isLoading
        ? buildLoadingIndicator()
        : ListView.builder(
            key: _listKey,
            controller: scrollController,
            itemCount:
                state.data.length + (hasMoreData(state.data, total) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.data.length) {
                return itemBuildFunction(context, state.data, index);
              } else {
                return state.isLoading
                    ? buildLoadingIndicator()
                    : buildLoadMoreButton(context, state, provider);
              }
            },
          );
  }
}
