import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import '../../Model/user_Model.dart';

class UserModel {
  Future<dynamic> insertUser(UserList user, Database db) async {
    try {
      int id = await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Fluttertoast.showToast(msg: "User Login Successfully");
      return id;
    } catch (e) {
      return Fluttertoast.showToast(
        msg: "Something went wrong please try again later",
      );
    }
  }
  Future<dynamic> getUser(Database db)async{
    final user = await db.query('users',columns: ['UUId']);
    print(user);
    return user;
  }
}
