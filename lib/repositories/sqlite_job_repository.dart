import '../models/job_offer.dart';
import '../services/job_database.dart';
import 'job_repository.dart';

class SqliteJobRepository implements JobRepository {
  SqliteJobRepository(this.database);

  final JobDatabase database;

  @override
  Future<List<JobOffer>> getJobs() {
    return database.getJobs();
  }

  @override
  Future<int> insertJob(JobOffer job) {
    return database.insertJob(job);
  }

  @override
  Future<int> updateJob(JobOffer job) {
    return database.updateJob(job);
  }

  @override
  Future<int> deleteJob(int id) {
    return database.deleteJob(id);
  }
}
