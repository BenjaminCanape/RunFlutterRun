import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../common/core/utils/user_utils.dart';

import '../../../domain/entities/user.dart';
import '../../common/core/utils/color_utils.dart';

class SearchWidget extends HookConsumerWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Future<List<User>> Function(String) onSearchChanged;

  const SearchWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: ColorUtils.white,
      title: TypeAheadField<User>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '${AppLocalizations.of(context)!.search}...',
            border: InputBorder.none,
            suffixIconColor: ColorUtils.main,
            suffixIcon: const Icon(Icons.search),
          ),
        ),
        suggestionsCallback: (String query) async {
          if (query.isNotEmpty) {
            return await onSearchChanged(query);
          }
          return [];
        },
        itemBuilder: (BuildContext context, User suggestion) {
          return ListTile(
              title: Text(
            suggestion.firstname != null && suggestion.lastname != null
                ? '${suggestion.firstname} ${suggestion.lastname}'
                : suggestion.username,
          ));
        },
        onSuggestionSelected: (User suggestion) =>
            UserUtils.goToProfile(suggestion),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
