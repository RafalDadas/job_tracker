import '../models/job_offer.dart';
import '../repositories/job_repository.dart';

class JobController {
  JobController(this.repository);

  final JobRepository repository;

  List<JobOffer> jobs = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadJobs() async {
    isLoading = true;
    errorMessage = null;

    try {
      jobs = await repository.getJobs();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<JobOffer> addJob(JobOffer job) async {
    final int id = await repository.insertJob(job);
    final JobOffer savedJob = job.copyWith(id: id);

    jobs.add(savedJob);

    return savedJob;
  }

  Future<void> updateJob(JobOffer job) async {
    await repository.updateJob(job);

    final int index = jobs.indexWhere((JobOffer item) => item.id == job.id);

    if (index != -1) {
      jobs[index] = job;
    }
  }

  Future<void> deleteJob(int id) async {
    await repository.deleteJob(id);
    jobs.removeWhere((JobOffer job) => job.id == id);
  }
}
