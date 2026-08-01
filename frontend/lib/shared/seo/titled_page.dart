import 'package:flutter/widgets.dart';

import 'page_title.dart';

/// Sets the browser tab title the moment this route builds, then renders
/// [child] unchanged. Wrap each GoRoute's builder with this so every screen
/// gets its own distinct, search-relevant title instead of sharing the one
/// static title in index.html.
class TitledPage extends StatefulWidget {
  const TitledPage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<TitledPage> createState() => _TitledPageState();
}

class _TitledPageState extends State<TitledPage> {
  @override
  void initState() {
    super.initState();
    setPageTitle(widget.title);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
