import 'package:flutter/material.dart';

import '../models/job_offer.dart';
import '../repositories/job_repository.dart';
import '../repositories/sqlite_job_repository.dart';
import '../screens/job_details_screen.dart';
import '../services/job_database.dart';
import '../widgets/job_statistics.dart';
import 'add_job_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

enum JobSortOption { company, position }

class _JobListScreenState extends State<JobListScreen> {
  late final JobRepository repository;

  JobSortOption jobSortOption = JobSortOption.company;
  List<JobOffer> jobs = [];
  List<Status?> statusOptions = [null, ...Status.values];
  bool isLoading = true;
  String searchQuery = '';
  String? errorMessage;
  Status? selectedStatus;

  List<JobOffer> get filteredJobs {
    List<JobOffer> filteredJobs = jobs.where((JobOffer job) {
      final bool matchesSearch =
          job.position.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job.company.toLowerCase().contains(searchQuery.toLowerCase());
      final bool matchesStatus =
          selectedStatus == null || job.status == selectedStatus;
      return matchesStatus && matchesSearch;
    }).toList();

    filteredJobs.sort((JobOffer a, JobOffer b) {
      switch (jobSortOption) {
        case JobSortOption.company:
          return a.company.compareTo(b.company);
        case JobSortOption.position:
          return a.position.compareTo(b.position);
      }
    });

    return filteredJobs;
  }

  int countByStatus(Status status) {
    return jobs.where((JobOffer job) => job.status == status).length;
  }

  Future<void> _loadJobs() async {
    try {
      final List<JobOffer> jobsList = await repository.getJobs();
      if (!mounted) return;
      setState(() {
        jobs = jobsList;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    repository = SqliteJobRepository(JobDatabase());
    _loadJobs();
  }

  Widget _buildJobCards() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    } else if (jobs.isEmpty) {
      return const Center(child: Text('No jobs yet.'));
    } else if (filteredJobs.isEmpty) {
      return const Center(child: Text('No jobs match this filter.'));
    } else {
      return ListView.builder(
        itemCount: filteredJobs.length,
        itemBuilder: (BuildContext context, int index) {
          final JobOffer job = filteredJobs[index];

          return JobCard(
            job: job,
            onChanged: (JobOffer newJobOffer) async {
              try {
                await repository.updateJob(newJobOffer);

                if (!mounted) return;

                setState(() {
                  final int index = jobs.indexWhere(
                    (item) => item.id == newJobOffer.id,
                  );
                  if (index != -1) {
                    jobs[index] = newJobOffer;
                  }
                });
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating job: $e')),
                  );
                }
              }
            },
            onDismissed: () {
              setState(() {
                jobs.removeWhere((jobToDelete) => jobToDelete.id == job.id);
              });
            },
            confirmDismiss: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                      'Are you sure you want to delete this job?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                try {
                  await repository.deleteJob(job.id!);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting job: $e')),
                    );
                  }
                  return false;
                }
              }
              return confirm ?? false;
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Tracker')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search company, position or location',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (String value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          DropdownButton<Status?>(
            value: selectedStatus,
            items: statusOptions.map((Status? status) {
              return DropdownMenuItem<Status?>(
                value: status,
                child: Text(status?.label ?? 'All'),
              );
            }).toList(),
            onChanged: (Status? newValue) {
              setState(() {
                selectedStatus = newValue;
              });
            },
          ),
          DropdownButton<JobSortOption>(
            value: jobSortOption,
            items: JobSortOption.values.map((JobSortOption option) {
              return DropdownMenuItem<JobSortOption>(
                value: option,
                child: Text(option.name),
              );
            }).toList(),
            onChanged: (JobSortOption? newValue) {
              if (newValue == null) return;

              setState(() {
                jobSortOption = newValue;
              });
            },
          ),
          JobStatistics(jobs: jobs),
          Expanded(child: _buildJobCards()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final JobOffer? newJob = await Navigator.of(context).push<JobOffer>(
              MaterialPageRoute(
                builder: (BuildContext context) => AddJobScreen(),
              ),
            );

            if (newJob != null) {
              final int insertedJobId = await repository.insertJob(newJob);
              final JobOffer insertedJob = newJob.copyWith(id: insertedJobId);

              if (!mounted) return;

              setState(() {
                jobs.add(insertedJob);
              });
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error adding job: $e')));
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.job,
    required this.onChanged,
    required this.onDismissed,
    required this.confirmDismiss,
  });

  final JobOffer job;
  final ValueChanged<JobOffer> onChanged;
  final VoidCallback onDismissed;
  final Future<bool> Function() confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(job.id),
      confirmDismiss: (DismissDirection direction) {
        return confirmDismiss();
      },
      child: InkWell(
        onTap: () async {
          final JobOffer? updatedJob = await Navigator.of(context)
              .push<JobOffer>(
                MaterialPageRoute(
                  builder: (BuildContext context) => JobDetailsScreen(job: job),
                ),
              );
          if (updatedJob != null) {
            onChanged(updatedJob);
          }
        },
        child: Card(
          child: Column(
            children: [
              Text(job.position),
              Text(job.company),
              Text(job.location),
              Text(job.status.label),
            ],
          ),
        ),
      ),
    );
  }
}
