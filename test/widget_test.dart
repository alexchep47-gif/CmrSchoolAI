import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cmr_school_ai/main.dart';

void main() {
  testWidgets('onboarding displays the level selection', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CmrSchoolApp()));
    expect(find.text('Mon niveau scolaire'), findsOneWidget);
    expect(find.text('SIL'), findsOneWidget);
  });
}
