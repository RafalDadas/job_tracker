enum Status { saved, applied, interview, rejected, offer }

class JobOffer {
  const JobOffer({
    required this.id,
    required this.company,
    required this.position,
    required this.location,
    this.salary,
    required this.status,
  });

  final int id;
  final String company;
  final String position;
  final String location;
  final double? salary;
  final Status status;

  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'],
      company: json['company'],
      position: json['position'],
      location: json['location'],
      salary: json['salary'],
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
      'status': status.name,
    };
  }

  JobOffer copyWith({Status? status}) {
    return JobOffer(
      id: id,
      company: company,
      position: position,
      location: location,
      salary: salary,
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
}
