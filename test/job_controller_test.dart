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
