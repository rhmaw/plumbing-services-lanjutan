import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user_entity.dart';

class UserLocalDataSource {
  static Database? _db;


  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'user.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user(
            email TEXT PRIMARY KEY,
            name TEXT,
            phone TEXT,
            address TEXT
          )
        ''');
      },
    );
  }


  Future<User?> getUser() async {
    final db = await database;

    final result = await db.query(
      'user',
      limit: 1,
    );

    if (result.isEmpty) return null;

    final u = result.first;
    return User(
      name: u['name'] as String,
      email: u['email'] as String,
      phone: u['phone'] as String,
      address: u['address'] as String,
    );
  }


  Future<void> saveProfile(User user) async {
    final db = await database;

  
    await db.insert(
      'user',
      {
        'email': user.email,
        'name': user.name,
        'phone': user.phone,
        'address': user.address,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> logout() async {
    final db = await database;
    await db.delete('user');
  }
}
