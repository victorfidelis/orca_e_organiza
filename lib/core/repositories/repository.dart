import 'package:sqflite/sqflite.dart';

class Repository {
  static const dataBaseName = 'eventData.db';
  static late String dataBaseFullName;

  // Capturando o banco de dados do app
  static Future<Database> getDataBase() async {
    final String dataBasePath = await getDatabasesPath();
    dataBaseFullName = '$dataBasePath$dataBaseName';

    Database database = await openDatabase(
      dataBaseFullName,
      onOpen: createTables,
    );

    return database;
  }

  // Criação das tabelas necessárias para o uso do app
  static Future<void> createTables(Database database) async {
    int? linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        ['Events'],
      ),
    );
    if (linesEvents != 1) {
      await database.execute(
        'CREATE TABLE Events ('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'date INT, '
            'start TEXT, '
            'end TEXT, '
            'theme TEXT)',
      );
    }

    linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        ['Events', '%theme%'],
      ),
    );

    if (linesEvents != 1) {
      await database.execute('ALTER TABLE Events ADD COLUMN theme TEXT');
    }

    linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        ['Modalities'],
      ),
    );
    if (linesEvents != 1) {
      await database.execute(
        'CREATE TABLE Modalities (id INTEGER PRIMARY KEY, eventId INTEGER, name TEXT)',
      );
    }

    linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        ['Budgets'],
      ),
    );
    if (linesEvents != 1) {
      await database.execute(
        'CREATE TABLE Budgets ('
            'id INTEGER PRIMARY KEY, '
            'modalityId INTEGER, '
            'name TEXT, '
            'value REAL, '
            'description TEXT, '
            'check_ INTEGER, '
            'address TEXT, '
            'phone TEXT,'
            'site TEXT,'
            'email TEXT)',
      );
    }

    linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        ['Budgets', '%phone%'],
      ),
    );

    if (linesEvents != 1) {
      await database.execute('ALTER TABLE Budgets ADD COLUMN address TEXT');
      await database.execute('ALTER TABLE Budgets ADD COLUMN phone TEXT');
    }

    linesEvents = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ? AND sql LIKE ?',
        ['Budgets', '%site%'],
      ),
    );

    if (linesEvents != 1) {
      await database.execute('ALTER TABLE Budgets ADD COLUMN site TEXT');
      await database.execute('ALTER TABLE Budgets ADD COLUMN email TEXT');
    }
  }
}
