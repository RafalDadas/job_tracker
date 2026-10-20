import 'package:flutter/material.dart';

import '../models/job_offer.dart';
import '../repositories/job_repository.dart';
import '../repositories/sqlite_job_repository.dart';
import '../screens/job_details_screen.dart';
import '../services/job_database.dart';
import 'add_job_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late final JobRepository repository;

  List<JobOffer> jobs = [];
  bool isLoading = true;
  String? errorMessage;

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

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text('Error: $errorMessage'));
    } else if (jobs.isEmpty) {
      return const Center(child: Text('No jobs yet.'));
    } else {
      return ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          JobOffer job = jobs[index];

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
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final JobOffer? newJob = await Navigator.of(context).push<JobOffer>(
              MaterialPageRoute(
                builder: (BuildContext context) => AddJobScreen(jobs: jobs),
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
