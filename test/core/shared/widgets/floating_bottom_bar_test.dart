import 'package:dreamdwell/core/shared/widgets/floating_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FloatingBottomBar renders correctly and handles taps',
      (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return FloatingBottomBar(
                items: const ['Buy', 'Rent', 'Lease'],
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Buy'), findsOneWidget);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Lease'), findsOneWidget);

    // Verify 'Buy' is selected (white background, primary text)
    // Note: It's hard to test exact colors without finding the specific Container,
    // but we can verify the text is present.
    // For more robust testing, we could find the AnimatedContainer.

    // Tap 'Rent'
    await tester.tap(find.text('Rent'));
    await tester.pumpAndSettle();

    // Verify state change
    expect(selectedIndex, 1);
  });
}
