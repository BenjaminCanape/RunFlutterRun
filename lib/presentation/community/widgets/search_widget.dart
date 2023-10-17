import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:run_flutter_run/domain/entities/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../view_model/community_view_model.dart';

class SearchWidget extends HookConsumerWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Future<List<User>> Function(String) onSearchChanged;

  const SearchWidget({
    Key? key,
    required this.searchController,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(communityViewModelProvider.notifier);
    return AppBar(
      backgroundColor: Colors.white,
      title: TypeAheadField<User>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '${AppLocalizations.of(context)!.search}...',
            border: InputBorder.none,
            suffixIconColor: Colors.teal.shade800,
            suffixIcon: const Icon(Icons.search),
          ),
        ),
        suggestionsCallback: (String query) async {
          return await onSearchChanged(query);
        },
        itemBuilder: (BuildContext context, User suggestion) {
          return ListTile(
            title: Text(suggestion.username),
          );
        },
        onSuggestionSelected: (User suggestion) =>
            provider.goToUserProfile(suggestion),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
