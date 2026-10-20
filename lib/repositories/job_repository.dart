import '../models/job_offer.dart';

abstract class JobRepository {
  Future<List<JobOffer>> getJobs();

  Future<int> insertJob(JobOffer job);

  Future<int> updateJob(JobOffer job);

  Future<int> deleteJob(int id);
}
