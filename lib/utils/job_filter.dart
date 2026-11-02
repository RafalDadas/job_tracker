import '../models/job_offer.dart';

enum JobSortOption { company, position }

List<JobOffer> filterJobs(
  List<JobOffer> jobs,
  String searchQuery,
  Status? selectedStatus,
) {
  final String query = searchQuery.toLowerCase();

  return jobs.where((JobOffer job) {
    final bool matchesSearch =
        job.position.toLowerCase().contains(query) ||
        job.location.toLowerCase().contains(query) ||
        job.company.toLowerCase().contains(query);

    final bool matchesStatus =
        selectedStatus == null || job.status == selectedStatus;

    return matchesSearch && matchesStatus;
  }).toList();
}

List<JobOffer> sortJobs(List<JobOffer> jobs, JobSortOption sortOption) {
  final List<JobOffer> sortedJobs = [...jobs];

  sortedJobs.sort((JobOffer a, JobOffer b) {
    switch (sortOption) {
      case JobSortOption.company:
        return a.company.compareTo(b.company);
      case JobSortOption.position:
        return a.position.compareTo(b.position);
    }
  });

  return sortedJobs;
}
