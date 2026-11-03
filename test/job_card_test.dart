import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/models/job_offer.dart';
import 'package:job_tracker/screens/job_list_screen.dart';

void main() {
  testWidgets('JobCard displays job information', (WidgetTester tester) async {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.applied,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JobCard(
            job: job,
            onChanged: (_) {},
            onDismissed: () {},
            confirmDismiss: () async => true,
          ),
        ),
      ),
    );

    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Warsaw'), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);
  });

  testWidgets('JobCard opens JobDetailsScreen', (WidgetTester tester) async {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.applied,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JobCard(
            job: job,
            onChanged: (_) {},
            onDismissed: () {},
            confirmDismiss: () async => true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Flutter Developer'));
    await tester.pumpAndSettle();

    expect(find.text('Google'), findsOneWidget);
  });
}
