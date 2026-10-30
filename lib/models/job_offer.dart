import 'package:flutter/material.dart';

enum Status { saved, applied, interview, rejected, offer }

class JobOffer {
  const JobOffer({
    this.id,
    required this.company,
    required this.position,
    required this.location,
    this.salary,
    this.appliedAt,
    required this.status,
  });

  final int? id;
  final String company;
  final String position;
  final String location;
  final double? salary;
  final DateTime? appliedAt;
  final Status status;

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'],
      company: json['company'],
      position: json['position'],
      location: json['location'],
      salary: json['salary'],
      appliedAt: json['applied_at'] != null
          ? DateTime.parse(json['applied_at'] as String)
          : null,
      status: Status.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'location': location,
      'salary': salary,
      'applied_at': appliedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  JobOffer copyWith({
    int? id,
    String? company,
    String? position,
    String? location,
    double? salary,
    DateTime? appliedAt,
    Status? status,
  }) {
    return JobOffer(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
    );
  }
}

extension StatusX on Status {
  String get label {
    switch (this) {
      case Status.saved:
        return 'Saved';
      case Status.applied:
        return 'Applied';
      case Status.interview:
        return 'Interview';
      case Status.rejected:
        return 'Rejected';
      case Status.offer:
        return 'Offer';
    }
  }

  Color get color {
    switch (this) {
      case Status.saved:
        return Colors.grey.shade300;
      case Status.applied:
        return Colors.blue.shade100;
      case Status.interview:
        return Colors.orange.shade100;
      case Status.rejected:
        return Colors.red.shade100;
      case Status.offer:
        return Colors.green.shade100;
    }
  }
}
