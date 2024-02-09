import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../domain/entities/activity.dart';
import '../../common/core/utils/activity_utils.dart';
import '../../common/core/utils/color_utils.dart';
import '../../common/core/utils/ui_utils.dart';
import '../view_model/activity_details_view_model.dart';
import '../widgets/details_tab.dart';
import '../widgets/graph_tab.dart';

/// The screen that displays details of a specific activity.
class ActivityDetailsScreen extends HookConsumerWidget {
  final Activity activity;

  const ActivityDetailsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityDetailsViewModelProvider);
    final provider = ref.read(activityDetailsViewModelProvider.notifier);

    final tabController = useTabController(initialLength: 2);

    final displayedActivity = state.activity ?? activity;

    return Scaffold(
      body: state.isLoading
          ? Center(child: UIUtils.loader)
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 25, top: 12),
                    child: Row(children: [
                      Text(
                        ActivityUtils.translateActivityTypeValue(
                          AppLocalizations.of(context)!,
                          displayedActivity.type,
                        ),
                        style: TextStyle(
                            color: ColorUtils.blueGrey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        color: ColorUtils.black,
                        tooltip: 'Edit',
                        onPressed: () {
                          tabController.animateTo(0);
                          provider.editType();
                        },
                        icon: Icon(
                          Icons.edit,
                          color: ColorUtils.blueGrey,
                        ),
                      ),
                      IconButton(
                        color: ColorUtils.black,
                        tooltip: 'Remove',
                        onPressed: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title: AppLocalizations.of(context)!
                                  .ask_activity_removal,
                              confirmBtnText:
                                  AppLocalizations.of(context)!.delete,
                              cancelBtnText:
                                  AppLocalizations.of(context)!.cancel,
                              confirmBtnColor: ColorUtils.red,
                              onCancelBtnTap: () => Navigator.of(context).pop(),
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                                provider.removeActivity(displayedActivity);
                              });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: ColorUtils.red,
                        ),
                      )
                    ]),
                  ),
                  Expanded(
                      child: DefaultTabController(
                          length: 2,
                          child: Scaffold(
                              appBar: TabBar(
                                  controller: tabController,
                                  labelColor: ColorUtils.blueGrey,
                                  dividerColor: ColorUtils.blueGrey,
                                  indicatorColor: ColorUtils.blueGrey,
                                  tabs: const [
                                    Tab(
                                      icon: Icon(Icons.short_text),
                                    ),
                                    Tab(
                                      icon: Icon(Icons.graphic_eq_outlined),
                                    ),
                                  ]),
                              body: TabBarView(
                                  controller: tabController,
                                  children: [
                                    DetailsTab(activity: activity),
                                    GraphTab(activity: activity)
                                  ]))))
                ],
              ),
            ),
    );
  }
}
