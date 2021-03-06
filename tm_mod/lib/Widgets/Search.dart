import 'package:flutter/material.dart';
import 'package:tm_modder/Widgets/CustomDiv.dart';

/// Adapted from internal Search.dart file, modified types, build, removed animations, public

enum _SearchBody {
  /// Suggested queries are shown in the body.
  ///
  /// The suggested queries are generated by [SearchDelegate.buildSuggestions].
  suggestions,

  /// Search results are currently shown in the body.
  ///
  /// The search results are generated by [SearchDelegate.buildResults].
  results,
}

abstract class SearchDelegate<T> {

  SearchDelegate({
    this.searchFieldLabel,
    this.searchFieldStyle,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  }) {
    _currentBody = _SearchBody.suggestions;
  }

  Widget buildSuggestions(BuildContext context);

  Widget buildResults(BuildContext context);

  Widget buildLeading(BuildContext context);

  List<Widget> buildActions(BuildContext context);

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  String get query => _queryTextController.text;
  set query(String value) {
    assert(query != null);
    _queryTextController.text = value;
  }

  void showResults(BuildContext context) {
    _focusNode?.unfocus();
    _currentBody = _SearchBody.results;
  }

  void showSuggestions(BuildContext context) {
    assert(_focusNode != null, '_focusNode must be set by route before showSuggestions is called.');
    _focusNode.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  void close(BuildContext context, T result) {
    _currentBody = null;
    _focusNode?.unfocus();
  }

  final String searchFieldLabel;

  final TextStyle searchFieldStyle;

  final TextInputType keyboardType;

  final TextInputAction textInputAction;

  // The focus node to use for manipulating focus on the search page. This is
  // managed, owned, and set by the _SearchPageRoute using this delegate.
  FocusNode _focusNode;

  final TextEditingController _queryTextController = TextEditingController();

  final ValueNotifier<_SearchBody> _currentBodyNotifier = ValueNotifier<_SearchBody>(null);

  _SearchBody get _currentBody => _currentBodyNotifier.value;
  set _currentBody(_SearchBody value) {
    _currentBodyNotifier.value = value;
  }

}

class SearchTile<T> extends StatefulWidget {
  const SearchTile(this.delegate);

  final SearchDelegate<T> delegate;

  @override
  State<StatefulWidget> createState() => _SearchTileState<T>();
}

class _SearchTileState<T> extends State<SearchTile<T>> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate._focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate._focusNode = null;
    focusNode.dispose();
  }

  @override
  void didUpdateWidget(SearchTile<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate._queryTextController.removeListener(_onQueryChanged);
      widget.delegate._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
      widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate._focusNode = null;
      widget.delegate._focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus && widget.delegate._currentBody != _SearchBody.suggestions) {
      widget.delegate.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  Row _buildSearchBar(theme, searchFieldLabel, searchFieldStyle) {
    var children = <Widget>[
      Padding(
        child: widget.delegate.buildLeading(context),
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      ),
    ];

    children.add(Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: widget.delegate._queryTextController,
          focusNode: focusNode,
          style: theme.textTheme.headline6,
          textInputAction: widget.delegate.textInputAction,
          keyboardType: widget.delegate.keyboardType,
          onSubmitted: (String _) {
            widget.delegate.showResults(context);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: searchFieldLabel,
            hintStyle: searchFieldStyle,
          ),
        ),
      ),
    ));

    children.addAll(widget.delegate.buildActions(context));

    return Row(children: children,);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate.appBarTheme(context);
    final String searchFieldLabel = widget.delegate.searchFieldLabel
        ?? MaterialLocalizations.of(context).searchFieldLabel;
    final TextStyle searchFieldStyle = widget.delegate.searchFieldStyle
        ?? theme.inputDecorationTheme.hintStyle;
    Widget body;
    switch(widget.delegate._currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate.buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate.buildResults(context),
        );
        break;
    }

    return Column(
      children: [
        _buildSearchBar(theme, searchFieldLabel, searchFieldStyle),
        CustomDiv(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Align(
              child: body,
              alignment: Alignment.topCenter,
            ),
          )
          ),
      ]);
  }
}
