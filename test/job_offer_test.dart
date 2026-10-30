import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/models/job_offer.dart';

void main() {
  test('Status label returns correct text', () {
    expect(Status.applied.label, 'Applied');
  });

  test('Status color returns correct collor', () {
    expect(Status.applied.color, Colors.blue.shade100);
  });

  test('JobOffer.fromJson creates correct JobOffer', () {
    final Map<String, dynamic> json = {
      'id': 1,
      'company': 'Google',
      'position': 'Flutter Developer',
      'location': 'Warsaw',
      'salary': 15000.0,
      'applied_at': '2026-10-30T10:00:00.000',
      'status': 'applied',
    };

    final JobOffer job = JobOffer.fromJson(json);

    expect(job.id, 1);
    expect(job.company, 'Google');
    expect(job.position, 'Flutter Developer');
    expect(job.location, 'Warsaw');
    expect(job.salary, 15000.0);
    expect(job.status, Status.applied);
    expect(job.appliedAt, DateTime(2026, 10, 30, 10));
  });

  test('JobOffer.toMap returns correct map', () {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      salary: 15000.0,
      appliedAt: DateTime(2026, 10, 30, 10),
      status: Status.applied,
    );

    final Map<String, dynamic> map = job.toMap();

    expect(map['id'], 1);
    expect(map['company'], 'Google');
    expect(map['position'], 'Flutter Developer');
    expect(map['location'], 'Warsaw');
    expect(map['salary'], 15000.0);
    expect(map['applied_at'], '2026-10-30T10:00:00.000');
    expect(map['status'], 'applied');
  });

  test('JobOffer can be serialized and deserialized', () {
    final JobOffer originalJob = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      salary: 15000.0,
      appliedAt: DateTime(2026, 10, 30, 10),
      status: Status.applied,
    );

    final Map<String, dynamic> map = originalJob.toMap();
    final JobOffer restoredJob = JobOffer.fromJson(map);

    expect(restoredJob.id, originalJob.id);
    expect(restoredJob.company, originalJob.company);
    expect(restoredJob.position, originalJob.position);
    expect(restoredJob.location, originalJob.location);
    expect(restoredJob.salary, originalJob.salary);
    expect(restoredJob.appliedAt, originalJob.appliedAt);
    expect(restoredJob.status, originalJob.status);
  });
}
