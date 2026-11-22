import 'package:flutter_test/flutter_test.dart';

import 'package:job_tracker/controllers/job_controller.dart';
import 'package:job_tracker/models/job_offer.dart';
import 'package:job_tracker/repositories/job_repository.dart';

class FakeJobRepository implements JobRepository {
  final List<JobOffer> jobs = [];
  int nextId = 1;

  @override
  Future<List<JobOffer>> getJobs() async {
    return jobs;
  }

  @override
  Future<int> insertJob(JobOffer job) async {
    
    final int id = nextId++;
    jobs.add(job.copyWith(id: id));
    return id;
  }

  @override
  Future<int> updateJob(JobOffer job) async {
    final int index = jobs.indexWhere((JobOffer item) => item.id == job.id);
    if (index != -1) {
      jobs[index] = job;
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteJob(int id) async {
    final int initialLength = jobs.length;

    jobs.removeWhere((JobOffer job) => job.id == id);

    return initialLength - jobs.length;
  }
}

void main() {
  late FakeJobRepository repository;
  late JobController controller;

  setUp(() {
    repository = FakeJobRepository();
    controller = JobController(repository);
  });

  tearDown(() {
    controller.dispose();
  });

  test('loadJobs loads jobs and notifies listeners', () async {
    repository.jobs.add(
      JobOffer(
        id: 1,
        company: 'Google',
        position: 'Flutter Developer',
        location: 'Remote',
        status: Status.applied,
      ),
    );

    int notificationCount = 0;
    controller.addListener(() {
      notificationCount++;
    });

    await controller.loadJobs();

    expect(controller.jobs.length, 1);
    expect(controller.jobs.first.company, 'Google');
    expect(controller.isLoading, false);
    expect(controller.errorMessage, isNull);
    expect(notificationCount, 2);
  });

  test('addJob saves job and notifies listeners', () async {
    final JobOffer job = JobOffer(
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Remote',
      status: Status.saved,
    );

    int notificationCount = 0;
    controller.addListener(() {
      notificationCount++;
    });

    final JobOffer savedJob = await controller.addJob(job);

    expect(savedJob.id, 1);
    expect(controller.jobs.length, 1);
    expect(controller.jobs.first.company, 'Google');
    expect(notificationCount, 1);
  });

  test('updateJob updates existing job and notifies listeners', () async {
    final JobOffer originalJob = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Junior Developer',
      location: 'Remote',
      status: Status.saved,
    );

    repository.jobs.add(originalJob);

    await controller.loadJobs();

    int notificationCount = 0;
    controller.addListener(() {
      notificationCount++;
    });

    final JobOffer updatedJob = originalJob.copyWith(
      position: 'Flutter Developer',
      status: Status.applied,
    );

    await controller.updateJob(updatedJob);

    expect(controller.jobs.length, 1);
    expect(controller.jobs.first.position, 'Flutter Developer');
    expect(controller.jobs.first.status, Status.applied);
    expect(notificationCount, 1);
  });

  test('deleteJob removes existing job and notifies listeners', () async {
    final JobOffer job = JobOffer(
      id: 1,
      company: 'Google',
      position: 'Flutter Developer',
      location: 'Remote',
      status: Status.applied,
    );

    repository.jobs.add(job);

    await controller.loadJobs();

    int notificationCount = 0;
    controller.addListener(() {
      notificationCount++;
    });

    await controller.deleteJob(1);

    expect(controller.jobs, isEmpty);
    expect(notificationCount, 1);
  });
}
