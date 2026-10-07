import 'package:flutter/material.dart';

import '../models/job_offer.dart';
import '../screens/job_details_screen.dart';
import '../services/job_database.dart';
import 'add_job_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final JobDatabase database = JobDatabase();
  List<JobOffer> jobs = [];

  Future<void> _loadJobs() async {
    List<JobOffer> jobsList = await database.getJobs();
    setState(() {
      jobs = jobsList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Tracker')),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return JobCard(
            job: jobs[index],
            onChanged: (JobOffer newJobOffer) {
              setState(() {
                jobs[index] = newJobOffer;
              });
            },
            onDismissed: () {
              setState(() {
                jobs.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final JobOffer? newJob = await Navigator.of(context).push<JobOffer>(
            MaterialPageRoute(
              builder: (BuildContext context) => AddJobScreen(jobs: jobs),
            ),
          );
          if (newJob != null) {
            setState(() {
              jobs.add(newJob);
            });
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
  });

  final JobOffer job;
  final ValueChanged<JobOffer> onChanged;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(job.id),
      onDismissed: (DismissDirection direction) {
        onDismissed();
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
