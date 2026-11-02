import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/models/job_offer.dart';
import 'package:job_tracker/utils/job_filter.dart';

void main() {
  test('filterJobs finds job by company', () {
    final List<JobOffer> jobs = [
      JobOffer(
        company: 'Google',
        position: 'Flutter Developer',
        location: 'Warsaw',
        status: Status.applied,
      ),
      JobOffer(
        company: 'Microsoft',
        position: 'Dart Developer',
        location: 'Warsaw',
        status: Status.saved,
      ),
    ];

    final List<JobOffer> result = filterJobs(jobs, 'google', null);

    expect(result.length, 1);
    expect(result.first.company, 'Google');
  });

  test('filterJobs filters jobs by status', () {
    final List<JobOffer> jobs = [
      JobOffer(
        company: 'Google',
        position: 'Flutter Developer',
        location: 'Warsaw',
        status: Status.applied,
      ),
      JobOffer(
        company: 'Microsoft',
        position: 'Dart Developer',
        location: 'Warsaw',
        status: Status.saved,
      ),
    ];

    final List<JobOffer> result = filterJobs(jobs, '', Status.applied);

    expect(result.length, 1);
    expect(result.first.status, Status.applied);
  });

  test('filterJobs returns all jobs when status is not selected', () {
    final List<JobOffer> jobs = [
      JobOffer(
        company: 'Google',
        position: 'Flutter Developer',
        location: 'Warsaw',
        status: Status.applied,
      ),
      JobOffer(
        company: 'Microsoft',
        position: 'Dart Developer',
        location: 'Warsaw',
        status: Status.saved,
      ),
    ];

    final List<JobOffer> result = filterJobs(jobs, '', null);

    expect(result.length, 2);
  });
}
