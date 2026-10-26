import 'package:flutter/material.dart';

import '../models/job_offer.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key, this.job});

  final JobOffer? job;

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      companyController.text = widget.job!.company;
      locationController.text = widget.job!.location;
      positionController.text = widget.job!.position;
      salaryController.text = widget.job!.salary?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (() {
              final double? salary = double.tryParse(
                salaryController.text.trim().replaceAll(',', '.'),
              );
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (widget.job == null) {
                Navigator.pop(
                  context,
                  JobOffer(
                    company: companyController.text.trim(),
                    location: locationController.text.trim(),
                    position: positionController.text.trim(),
                    salary: salary,
                    status: Status.saved,
                  ),
                );
              } else {
                Navigator.pop(
                  context,
                  widget.job!.copyWith(
                    company: companyController.text.trim(),
                    location: locationController.text.trim(),
                    position: positionController.text.trim(),
                    salary: salary,
                  ),
                );
              }
            }),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Position'),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a position';
                }
                return null;
              },
            ),
            TextFormField(
              controller: companyController,
              decoration: const InputDecoration(labelText: 'Company'),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a company';
                }
                return null;
              },
            ),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            TextFormField(
              controller: salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return null;
                }

                final double? salary = double.tryParse(
                  value.trim().replaceAll(',', '.'),
                );

                if (salary == null || salary < 0) {
                  return 'Please enter a valid salary';
                }

                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    companyController.dispose();
    locationController.dispose();
    positionController.dispose();
    salaryController.dispose();
    super.dispose();
  }
}
