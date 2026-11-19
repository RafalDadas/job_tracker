import 'package:flutter/foundation.dart';

import '../models/job_offer.dart';
import '../repositories/job_repository.dart';

class JobController extends ChangeNotifier {
  JobController(this.repository);

  final JobRepository repository;
  final List<JobOffer> _jobs = [];
  List<JobOffer> get jobs => List.unmodifiable(_jobs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadJobs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs
        ..clear()
        ..addAll(await repository.getJobs());
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<JobOffer> addJob(JobOffer job) async {
    final int id = await repository.insertJob(job);
    final JobOffer savedJob = job.copyWith(id: id);

    _jobs.add(savedJob);
    notifyListeners();

    return savedJob;
  }

  Future<void> updateJob(JobOffer job) async {
    await repository.updateJob(job);

    final int index = _jobs.indexWhere((JobOffer item) => item.id == job.id);

    if (index != -1) {
      _jobs[index] = job;
      notifyListeners();
    }
  }

  Future<void> deleteJob(int id) async {
    await repository.deleteJob(id);

    final int initialLength = _jobs.length;
    _jobs.removeWhere((JobOffer job) => job.id == id);

    if (_jobs.length != initialLength) {
      notifyListeners();
    }
  }
}
