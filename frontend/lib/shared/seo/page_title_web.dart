// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Updates the browser tab title (and what search-engine crawlers that
/// execute JS see per route, since Flutter web ships one static
/// `<title>` in index.html otherwise).
void setPageTitle(String title) {
  html.document.title = title;
}
