import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:medic_abroad_frontend/app.dart';

void main() {
  testWidgets('Landing screen renders brand and CTA', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MedicAbroadApp()),
    );
    await tester.pump();

    expect(find.text('Sree Consultancy'), findsOneWidget);
    expect(find.text('Start Your Application'), findsOneWidget);
  });
}
