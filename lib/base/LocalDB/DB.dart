import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Enexpense.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("oldVersion: $oldVersion, newVersion: $newVersion");

    if (oldVersion < newVersion) {
      await db.execute('''
    CREATE TABLE IF NOT EXISTS budget (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      uuid TEXT NOT NULL,
      budgetAmount INTEGER NOT NULL,
      budgetPurpose TEXT NOT NULL,              
      isRecurringBudget INTEGER NOT NULL DEFAULT 0,
      budgetType TEXT NOT NULL,                 
      period TEXT,                               
      budgetStartDate TIMESTAMP,
      budgetEndDate TIMESTAMP,
      recurringStartDate TIMESTAMP,
      recurringEndDate TIMESTAMP,
      budgetAlertTrigger_1 INTEGER,                     
      budgetAlertTrigger_2 INTEGER,                     
      budgetAlertAmount_1 INTEGER,
      budgetAlertAmount_2 INTEGER,
      budgetAlertPercentage_1 INTEGER,
      budgetAlertPercentage_2 INTEGER,
      categoryId INTEGER,
      tagId INTEGER,
      phoneNotification INTEGER NOT NULL DEFAULT 1,
      isEmailEnable INTEGER DEFAULT 0,
      email TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ''');
      await db.execute('''
    DELETE FROM recurring_events 
    WHERE id NOT IN (SELECT id FROM expenses)
  ''');
      final existingColumns = await db.rawQuery(
        "PRAGMA table_info(categories)",
      );
      final existRecurringColumns = await db.rawQuery(
        "PRAGMA table_info(recurring_events)",
      );
      final existReportToggleColumns = await db.rawQuery(
        "PRAGMA table_info(users)",
      );
      final existingTagsColumns = await db.rawQuery("PRAGMA table_info(tags)");
      final hasColorColumn = existingColumns.any(
        (column) => column['name'] == 'color',
      );
      final FirebaseUuid = existingColumns.any(
        (column) => column['name'] == 'firebaseUid',
      );
      final TagFirebaseUuid = existingTagsColumns.any(
        (column) => column['name'] == 'firebaseUid',
      );
      final CategoryOrderColumn = existingColumns.any(
        (column) => column['name'] == 'CategoryOrder',
      );
      final hasNeverColumn = existRecurringColumns.any(
        (column) => column['name'] == 'never',
      );

      final hasReportToggleColumn = existReportToggleColumns.any(
        (column) => column['name'] == 'reportToggle',
      );

      if (!hasColorColumn) {
        await db.execute('ALTER TABLE categories ADD COLUMN color TEXT');
        print('Color column added.');
      } else {
        print('Color column already exists, skipping ALTER TABLE.');
      }
      if (!CategoryOrderColumn) {
        await db.execute(
          'ALTER TABLE categories ADD COLUMN CategoryOrder INTEGER NOT NULL DEFAULT 0',
        );
        await db.execute('UPDATE categories SET CategoryOrder = categoryId');
      } else {
        print("CategoryOrder column already exists, skipping ALTER TABLE");
      }
      if (!FirebaseUuid) {
        await db.execute(
          'ALTER TABLE categories ADD COLUMN firebaseUid TEXT DEFAULT \'\'',
        );
        await db.execute('UPDATE categories SET firebaseUid = \'\'');
      } else {
        print('FirebaseUuid column already exists, skipping ALTER TABLE.');
      }
      if (!TagFirebaseUuid) {
        await db.execute(
          'ALTER TABLE tags ADD COLUMN firebaseUid TEXT DEFAULT \'\'',
        );
        await db.execute('UPDATE tags SET firebaseUid = \'\'');
      } else {
        print('FirebaseUuid column already exists, skipping ALTER TABLE.');
      }
      if (!hasReportToggleColumn) {
        await db.execute(
          "ALTER TABLE users ADD COLUMN reportToggle TEXT DEFAULT 'Overall Report'",
        );
        await db.execute("UPDATE users SET reportToggle = 'Overall Report'");
        print('reportToggle column added and initialized.');
      } else {
        print('reportToggle column already exists, skipping ALTER TABLE.');
      }

      if (!hasNeverColumn) {
        await db.execute(
          'ALTER TABLE recurring_events ADD COLUMN never INTEGER',
        );
        await db.execute(
          'ALTER TABLE recurring_events ADD COLUMN occurence INTEGER',
        );
        await db.execute(
          'UPDATE recurring_events SET never = 1 WHERE isExpenseAdd = 1',
        );
        await db.execute(
          'UPDATE recurring_events SET occurence = 0 WHERE isExpenseAdd = 1',
        );
      } else {
        print('never column already exists, skipping ALTER TABLE.');
      }

      final Map<String, String> categoryColors = {
        'Food': 'Color(0xFFFF443B)',
        'Groceries': 'Color(0xFF92DE6F)',
        'Travel': 'Color(0xFF1F5E4C)',
        'Medical': 'Color(0xFF801750)',
        'Personal Care': 'Color(0xFFFA8CA2)',
        'Education': 'Color(0xFF30BEFF)',
        'Bills': 'Color(0xFFA3128D)',
        'Rent': 'Color(0xFF1D4AA3)',
        'Taxes': 'Color(0xFFA0A2A3)',
        'Insurance': 'Color(0xFFBA72ED)',
        'Gifts': 'Color(0xFF2DB2A1)',
        'Movie': 'Color(0xFF53088C)',
        'Bike': 'Color(0xFFB78C01)',
        'Others(Expense)': 'Color(0xFFFFBABA)',
        'Salary': 'Color(0xFFD4E157)',
        'Sold Item': 'Color(0xFF90A4AE)',
        'Coupons': 'Color(0xFFFFB300)',
        'Others(Income)': 'Color(0xFFFFCA28)',
      };

      final existingCategories = await db.query('categories');
      final existingCategoryNames = existingCategories
          .map((category) => category['name'] as String?)
          .where((name) => name != null)
          .toSet();

      int othersExpenseOrder =
          existingCategories.firstWhere(
                (e) => e['name'] == 'Others(Expense)' && e['type'] == 'Expense',
                orElse: () => {'CategoryOrder': existingCategoryNames.length},
              )['CategoryOrder']
              as int;

      final newCategories = [
        {
          'name': 'Shopping',
          'color': 'Color(0xFFAEEA00)',
          'type': 'Expense',
          'icon': 'shopping',
        },
        {
          'name': 'Transport',
          'color': 'Color(0xFFF39C12)',
          'type': 'Expense',
          'icon': 'transport',
        },
      ];

      int insertOrder = othersExpenseOrder - newCategories.length;

      for (final category in newCategories) {
        if (!existingCategoryNames.contains(category['name'])) {
          await db.insert('categories', {
            'name': category['name'],
            'type': category['type'],
            'color': category['color'],
            'CategoryOrder': insertOrder++,
            'icon': category['icon'],
            'createdAt': DateTime.now().toIso8601String(),
            'isActive': 1,
            'firebaseUid': '',
          });
          print('Inserted ${category['name']}');
        }
      }

      final categories = await db.query('categories');

      for (final category in categories) {
        final name = category['name'] as String?;
        final color = category['color'] as String?;

        if (name == null || (color != null && color.trim().isNotEmpty)) {
          continue;
        }
        if (categoryColors.containsKey(name)) {
          await db.update(
            'categories',
            {'color': categoryColors[name]},
            where: 'name = ?',
            whereArgs: [name],
          );
        } else {
          final randomColor = _generateValidRandomColor();
          final formattedColor =
              'Color(0x${randomColor.value.toRadixString(16).toUpperCase().padLeft(8, '0')})';

          await db.update(
            'categories',
            {'color': formattedColor},
            where: 'name = ?',
            whereArgs: [name],
          );
        }
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBHelper && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  Color _generateValidRandomColor() {
    final Random random = Random();
    Color color;
    do {
      color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    } while (_isTooLight(color));
    return color;
  }

  bool _isTooLight(Color color) {
    final brightness =
        (color.red * 299 + color.green * 587 + color.blue * 114) / 1000;
    return brightness > 230;
  }

  Future<void> _createDB(Database db, int version) async {
    const tables = [
      '''
    CREATE TABLE users (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      UUId String NOT NULL
    )
    ''',
      '''
    CREATE TABLE tags (
      tagId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      createdAt TIMESTAMP NOT NULL,
      firebaseUid TEXT NOT NULL DEFAULT ' ',
      updatedAt TIMESTAMP
    )
    ''',
      '''
   CREATE TABLE currency(
  Id INTEGER PRIMARY KEY AUTOINCREMENT,
  target_currency TEXT,
  firebaseUid TEXT NOT NULL,
  rate TEXT,
  createdAt TIMESTAMP NOT NULL
) ''',
      '''
      CREATE TABLE categories (
        categoryId INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT,
        color TEXT,
        CategoryOrder INTEGER NOT NULL DEFAULT 0,
        createdAt TIMESTAMP NOT NULL,
        updatedAt TIMESTAMP,
        firebaseUid TEXT NOT NULL DEFAULT ' ',
        isActive INTEGER NOT NULL DEFAULT 0
      )
    ''',
      '''
    CREATE TABLE subscription_plans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subscriptiontype TEXT NOT NULL DEFAULT 'Free' CHECK(subscriptiontype IN ('Free', 'Basic', 'Pro', 'Enterprise')),
      subscriptionAmount INTEGER NOT NULL DEFAULT 0,
      imageUploadCount INTEGER NOT NULL DEFAULT 0,
      plan TEXT NOT NULL,
      amount REAL NOT NULL,
      feature TEXT NOT NULL,
      plandetails TEXT NOT NULL,
      createdAt TIMESTAMP NOT NULL,
      updatedAt TIMESTAMP NOT NULL,
      uid TEXT NOT NULL,
      email Text Not Null
    )
    ''',
      '''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL,
      ConvertedCurrency REAL,
      actualCurrency REAL,
      Country TEXT NOT NULL,
      description TEXT NULL,
      categoryId INTEGER NOT NULL,
      userId INTEGER NOT NULL,
      date TIMESTAMP NOT NULL,
      createdAt TIMESTAMP,
      updatedAt TIMESTAMP,
      notificationStartDate TIMESTAMP,
      notificationEndDate TIMESTAMP,
      merchantName TEXT,
      vendorName TEXT,
      type TEXT NOT NULL,
      tagId INTEGER,
      isRecurring INTEGER NOT NULL,
      accountType TEXT NOT NULL,
      imageJsonData TEXT,
      FOREIGN KEY (categoryId) REFERENCES categories(categoryId),
      FOREIGN KEY (userId) REFERENCES users(userId),
      FOREIGN KEY (tagId) REFERENCES tags(tagId)
   )
   ''',
      '''
   CREATE TABLE recurring_events (
    id INTEGER NOT NULL,
    tittle TEXT NOT NULL,
    description TEXT,
    selectedStartDate TIMESTAMP NOT NULL,
    selectedEndDate TIMESTAMP NOT NULL,
    occurence INTEGER,
    never INTEGER,
    repeatOption TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    isActive INTEGER,
    isExpenseAdd INTEGER
   );
   ''',
      '''
   CREATE TABLE budget (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uuid TEXT NOT NULL,
    budgetAmount INTEGER NOT NULL,
    budgetPurpose TEXT NOT NULL,              
    isRecurringBudget INTEGER NOT NULL DEFAULT 0,
    budgetType TEXT NOT NULL,                 
    period TEXT,                               
    budgetStartDate TIMESTAMP,
    budgetEndDate TIMESTAMP,
    recurringStartDate TIMESTAMP,
    recurringEndDate TIMESTAMP,
    budgetAlertTrigger_1 INTEGER,                     
    budgetAlertTrigger_2 INTEGER,                     
    budgetAlertAmount_1 INTEGER,
    budgetAlertAmount_2 INTEGER,
    budgetAlertPercentage_1 INTEGER,
    budgetAlertPercentage_2 INTEGER,
    categoryId INTEGER,
    tagId INTEGER,
    phoneNotification INTEGER NOT NULL DEFAULT 1,
    isEmailEnable INTEGER DEFAULT 0,
    email TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

   ''',
    ];

    for (var table in tables) {
      await db.execute(table);
    }
  }
}
