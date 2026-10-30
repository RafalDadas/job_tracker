import 'package:flutter/material.dart';

import '../models/job_offer.dart';

class JobStatistics extends StatelessWidget {
  const JobStatistics({super.key, required this.jobs});

  final List<JobOffer> jobs;

  int countByStatus(Status status) {
    return jobs.where((JobOffer job) => job.status == status).length;
  }

  int get totalJobs => jobs.length;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _StatisticCard(title: 'Total', value: totalJobs),
        ...Status.values.map((Status status) {
          return _StatisticCard(
            title: status.label,
            value: countByStatus(status),
          );
        }),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.title, required this.value});

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title),
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
