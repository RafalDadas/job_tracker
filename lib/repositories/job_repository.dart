import '../models/job_offer.dart';
import '../services/job_database.dart';

class JobRepository {
  JobRepository(this.database);

  final JobDatabase database;

  Future<List<JobOffer>> getJobs() {
    return database.getJobs();
  }

  Future<int> insertJob(JobOffer job) {
    return database.insertJob(job);
  }

  Future<int> updateJob(JobOffer job) {
    return database.updateJob(job);
  }

  Future<int> deleteJob(int id) {
    return database.deleteJob(id);
  }
}
