
import 'package:sqflite/sqflite.dart';

class RecordHelper {
  final int id;
  final String time ;
  final double score;
  //final String score;

  RecordHelper({this.id,this.time,this.score});

  Map <String, dynamic> toMap() {
    return {
      'id' : id,
      'time': time,
      'score': score,
    };
  }

  // 現在時間處理
  // String now = DateTime.now().toString();
  // print(now.substring(0,19));
}

class DBHelper {
  final sqlFileName = 'myRecord.db';
  final table = 'recordTable';
  Database db;

  /*openDB*/
  open()async{
    String dbPath = "${await getDatabasesPath()}/$sqlFileName";
    //print(dbPath);
    if(db==null){

      /*
      function use method :
         openDatabase(
            String path,
            onCreate: (Database db, int ver){ /*db_function*/ }
         )
      */
      db = await openDatabase (
        dbPath, version: 1,
        onCreate: (db, version) async{
          await db.execute(
            //"CREATE TABLE recordTable(id INTEGER PRIMARY KEY, time TEXT, score REAL)",
            "CREATE TABLE recordTable(id INTEGER PRIMARY KEY, time TEXT, score REAL)",
          );
        },
      );
    }
  }

  /*insert data into DB*/
  insert(RecordHelper records) async {
    /*
    function use method :
       database.insert(String table,Map<String, dynamic> values)
    */
    await db.insert(
      //要 table 名稱
      table, //'recordTable'
      //要 map 資料 : 呼叫 RecordHelper class 中的 toMap 函式，會return map 資料
      records.toMap(),
      //當資料發生衝突，定義將會採用 replace 覆蓋之前的資料
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  queryAll() async{
    return await db.query(table, columns: null); //columns: null 會回傳所有資料
  }

  delete(int id) async{
    return await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
      //也可這樣寫 where: "id = $id", 但沒那麼好
    );
  }

  getLength()async{
    // dynamic a = await db.rawQuery('''
    //   SELECT count(*) FROM $table
    // ''');
    // print(a);
    // return a;
    return await db.rawQuery('SELECT count(*) FROM $table');
  }

  getSortData()async{
    //原 "db.execute()" : Unhandled Exception: DatabaseException(unknown error (code 0): Queries can be performed using SQLiteDatabase query or rawQuery methods only.)
    return await db.rawQuery('SELECT * FROM $table ORDER BY score');
  }

  getShortestTime()async{
    return await db.rawQuery('SELECT MIN(score) FROM $table');
  }


  /*暫時用不到*/
  // updateRecords(RecordHelper records) async {
  //   await db.update(
  //     table,
  //     records.toMap(),
  //     where: "id = ?",
  //     whereArgs: [records.id],
  //   );
  // }


  /*test*/
  // var fido = Records(
  //   time: 0,
  //   score: 0,
  // );

  // await insertDog(fido);
  // print(await records());
  //
  // fido = Records(
  //   time: fido.time,
  //   score: fido.score,
  // );
  // await updateRecords(fido);
  // print(await records());
  //
  // await deleteRecords(fido.time);
  // print(await records());

}









