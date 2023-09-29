import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/presentation/community/view_model/community_view_model.dart';

import '../../common/core/widgets/activity_list.dart';
import '../widgets/search_widget.dart';

/// The screen that displays community infos
class CommunityScreen extends HookConsumerWidget {
  final TextEditingController _searchController = TextEditingController();

  CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(communityViewModelProvider.notifier);
    var state = ref.read(communityViewModelProvider);
    return Scaffold(
        appBar: SearchWidget(
          searchController: _searchController,
          onSearchChanged: (String query) {
            return provider.search(query);
          },
        ),
        body: SafeArea(child: ActivityList(activities: state.activities)));
  }
}
