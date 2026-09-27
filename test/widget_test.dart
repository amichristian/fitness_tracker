//B Munezero Ami christian
//2401000232
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/main.dart';

void main() {
  testWidgets('Fitness Tracker app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessTrackerApp());

    expect(find.text('Fitness Tracker'), findsOneWidget);
  });
}
