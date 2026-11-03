import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/models/job_offer.dart';
import 'package:job_tracker/services/job_database.dart';
import 'package:job_tracker/repositories/sqlite_job_repository.dart';

class FakeJobDatabase extends JobDatabase {
  @override
  Future<int> insertJob(JobOffer job) async {
    return 123;
  }

  @override
  Future<List<JobOffer>> getJobs() async {
    return [
      JobOffer(
        id: 1,
        company: 'Google',
        position: 'Flutter Developer',
        location: 'Warsaw',
        status: Status.applied,
      ),
    ];
  }

  @override
  Future<int> updateJob(JobOffer job) async {
    return 1;
  }

  @override
  Future<int> deleteJob(int id) async {
    return 1;
  }
}

void main() {
  test('insertJob returns id from database', () async {
    final FakeJobDatabase database = FakeJobDatabase();
    final SqliteJobRepository repository = SqliteJobRepository(database);
    final JobOffer job = JobOffer(
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.saved,
    );

    final int id = await repository.insertJob(job);
    expect(id, 123);
  });

  test('getJobs returns jobs from database', () async {
    final FakeJobDatabase database = FakeJobDatabase();
    final SqliteJobRepository repository = SqliteJobRepository(database);

    final List<JobOffer> jobs = await repository.getJobs();

    expect(jobs.length, 1);
    expect(jobs.first.company, 'Google');
    expect(jobs.first.position, 'Flutter Developer');
    expect(jobs.first.status, Status.applied);
  });

  test('updateJob returns number of updated rows', () async {
    final FakeJobDatabase database = FakeJobDatabase();
    final SqliteJobRepository repository = SqliteJobRepository(database);

    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Warsaw',
      status: Status.interview,
    );

    final int result = await repository.updateJob(job);
    expect(result, 1);
  });

  test('deleteJob returns number of deleted rows', () async {
    final FakeJobDatabase database = FakeJobDatabase();
    final SqliteJobRepository repository = SqliteJobRepository(database);

    final int result = await repository.deleteJob(1);
    expect(result, 1);
  });
}
