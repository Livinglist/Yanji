
import 'package:jiba/models/journal.dart';

import 'db_provider.dart';

class Repository{
  Future<void> deleteJournal(Journal journal) => DBProvider.db.deleteJournal(journal);

  Future<void> addJournal(Journal journal)=>DBProvider.db.addJournal(journal);

  Future<void> updateJournal(Journal journal) => DBProvider.db.updateJournal(journal);

  Future<List<Journal>> getAllJournals() => DBProvider.db.getAllJournals();

  Future<int> getNextId() => DBProvider.db.getNextId();
}

Repository repo = Repository();