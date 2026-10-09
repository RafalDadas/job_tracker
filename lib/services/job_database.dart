import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/job_offer.dart';

class JobDatabase {
  static const String _databaseName = 'job_tracker.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE jobs
          (
          id INTEGER PRIMARY KEY,
          company TEXT NOT NULL,
          position TEXT NOT NULL,
          location TEXT NOT NULL,
          salary REAL,
          status TEXT NOT NULL
          )
          ''');
      },
    );
  }

  Future<List<JobOffer>> getJobs() async {
    final db = await database;
    final List<Map<String, dynamic>> jobsMap = await db.query('jobs');
    return jobsMap.map((job) => JobOffer.fromJson(job)).toList();
  }

  Future<int> insertJob(JobOffer job) async {
    final db = await database;
    final Map<String, dynamic> data = job.toMap();
    data.remove('id');
    return db.insert('jobs', data);
  }

  Future<int> updateJob(JobOffer job) async {
    final db = await database;
    return db.update('jobs', job.toMap(), where: 'id = ?', whereArgs: [job.id]);
  }

  Future<int> deleteJob(int id) async {
    final db = await database;
    return db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }
}
