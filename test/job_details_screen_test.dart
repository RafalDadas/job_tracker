import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:job_tracker/models/job_offer.dart';
import 'package:job_tracker/screens/job_details_screen.dart';

void main() {
  testWidgets('JobDetailsScreen displays job information', (
    WidgetTester tester,
  ) async {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.applied,
    );

    await tester.pumpWidget(MaterialApp(home: JobDetailsScreen(job: job)));

    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Warsaw'), findsOneWidget);
    expect(find.text('Applied'), findsNWidgets(2));
  });

  testWidgets('JobDetailsScreen changes job status', (
    WidgetTester tester,
  ) async {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.saved,
    );

    await tester.pumpWidget(MaterialApp(home: JobDetailsScreen(job: job)));

    expect(find.text('Saved'), findsNWidgets(2));

    await tester.tap(find.byType(DropdownButton<Status>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Applied').last);
    await tester.pumpAndSettle();

    expect(find.text('Applied'), findsNWidgets(2));
  });
}
