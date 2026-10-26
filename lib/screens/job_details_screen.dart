import 'package:flutter/material.dart';

import '../models/job_offer.dart';
import 'add_job_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key, required this.job});

  final JobOffer job;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late JobOffer job;

  @override
  void initState() {
    super.initState();
    job = widget.job;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.position),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final JobOffer? updatedJob = await Navigator.push<JobOffer>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AddJobScreen(job: job),
                ),
              );

              if (updatedJob != null) {
                setState(() {
                  job = updatedJob;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (() {
              Navigator.pop(context, job);
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(job.company),
          Text(job.location),
          Text(job.status.label),
          DropdownButton<Status>(
            value: job.status,
            items: Status.values.map((Status status) {
              return DropdownMenuItem<Status>(
                value: status,
                child: Text(status.label),
              );
            }).toList(),
            onChanged: (Status? value) {
              if (value == null) return;

              setState(() {
                job = job.copyWith(status: value);
              });
            },
          ),
        ],
      ),
    );
  }
}
