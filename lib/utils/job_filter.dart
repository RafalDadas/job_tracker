import '../models/job_offer.dart';

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
