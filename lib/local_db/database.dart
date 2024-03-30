//
// import 'package:app/screens/Admin/Model/api_data_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
//
// class LocalDatabase{
//   static final LocalDatabase instance = LocalDatabase._init();
//   static Database? _database;
//
//   LocalDatabase._init();
//
//   Future<Database?> get database async{
//     if(_database != null) return _database;
//
//     return _database = await _initDb('comps.db');
//
//   }
//
//   Future<Database> _initDb(String filePath)async{
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(path, version: 1, onCreate: _createDb);
//   }
//
//   Future _createDb(Database db, int version)async{
//     final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     final textType= 'TEXT NOT NULL';
//     final integerType = 'INTEGER';
//     final primaryKey = 'TEXT NOT NULL';
//
//     await db.execute('''
//     CREATE TABLE $compCollection (
//     ${CompCollectionFields().docId} $textType,
//     ${CompCollectionFields().champListLength} $textType,
//     )
//     ''');
//     await db.execute('''
//     CREATE TABLE $champCollection (
//     ${ChampModelFields.compId} $textType
//     ${ChampModelFields.champName} $textType,
//     ${ChampModelFields.champCost} $textType,
//     ${ChampModelFields.champPositionIndex} $textType,
//     ${ChampModelFields.champTraits} $textType,
//     ${ChampModelFields.imagePath} $textType
//     )
//     ''');
//
//   }
//
//   Future<CompCollectionModel?> createComp(CompCollectionModel comp)async{
//     final db = await instance.database;
//     final id = await db?.insert(compCollection, comp.toMap());
//     // return null;
//     return comp.copy(docId: id);
//   }
//
//   Future<ChampModel?> createChamp(ChampModel champ)async{
//     final db = await instance.database;
//     final id = await db?.insert(champCollection, champ.toJson());
//     // return null;
//     return champ.copy(docId: id);
//   }
//
//   Future<CompCollectionModel?> readComp(int id)async{
//     final db = await instance.database;
//
//     final maps = await db?.query(
//         compCollection,
//         columns: ['Document Id',"ChampList Length"],
//         where: '${CompCollectionFields().docId} = ?',
//         whereArgs: [id]
//     );
//     if (maps!.isNotEmpty){
//       return CompCollectionModel.fromLocalDbJson(maps.first);
//     }else{
//       throw Exception('ID $id not found');
//     }
//   }
//
//   Future<ChampModel?> readCompChampList(int id)async{
//     final db = await instance.database;
//
//     final maps = await db?.query(
//         champCollection,
//         columns: ChampModelFields().localDbChampColumns,
//         where: '${ChampModelFields.compId} = ?',
//         whereArgs: [id]
//     );
//     if (maps!.isNotEmpty){
//       return ChampModel.fromJson(maps.first);
//     }else{
//       throw Exception('ID $id not found');
//     }
//   }
//
//
//   Future<List<CompCollectionModel>?> readAllComps()async{
//     final db = await instance.database;
//     final orderBy = '${CompCollectionFields().docId} ASC';
//     final result = await db?.query(compCollection, orderBy: orderBy);
//
//     return result?.map((json) => CompCollectionModel.fromLocalDbJson(json)).toList();
//
//   }
//
//   Future<List<ChampModel>?> readAllChamps()async{
//     final db = await instance.database;
//     const orderBy = '${ChampModelFields.champPositionIndex} ASC';
//     final result = await db?.query(champCollection, orderBy: orderBy);
//
//     return result?.map((json) => ChampModel.fromJson(json)).toList();
//
//   }
//
//   Future<Future<int>?> delete(int? id)async{
//     final db = await instance.database;
//     return db?.delete(
//         champCollection,
//         where: '${ChampModelFields.champPositionIndex} = ?',
//         whereArgs: [id]
//     );
//   }
//
//   Future close()async{
//     final db = await instance.database;
//     _database = null;
//     db?.close();
//   }
//
// }