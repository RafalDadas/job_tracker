import 'package:flutter/material.dart';

import '../models/job_offer.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key, required this.jobs});

  final List<JobOffer> jobs;

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (() {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              Navigator.pop(
                context,
                JobOffer(
                  company: companyController.text.trim(),
                  location: locationController.text.trim(),
                  position: positionController.text.trim(),
                  status: Status.saved,
                ),
              );
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
    super.dispose();
  }
}
