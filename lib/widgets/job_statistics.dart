import 'package:flutter/material.dart';

import '../models/job_offer.dart';

class JobStatistics extends StatelessWidget {
  const JobStatistics({super.key, required this.jobs});

  final List<JobOffer> jobs;

  int countByStatus(Status status) {
    return jobs.where((JobOffer job) => job.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: Status.values.map((Status status) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [Text(status.label), Text('$countByStatus(status)')],
            ),
          ),
        );
      }).toList(),
    );
  }
}
