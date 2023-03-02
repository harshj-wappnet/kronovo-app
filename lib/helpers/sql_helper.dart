import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class SQLHelper {

  static final _databaseName = "db_project.db";
  static final _databaseVersion = 1;

  static final project_table = 'tb_project';
  static final task_table = 'tb_task';
  static final sub_task_table = 'tb_sub_task';

  static final project_columnId = 'project_id';
  static final project_name = 'project_name';
  static final project_description = 'project_description';
  static final project_startDate = 'project_start_date';
  static final project_endDate = 'project_end_date';
  static final project_assigned_peoples = 'project_assigned_peoples';

  //static final project_people = 'project_people';

  static final tasks_columnId = 'column_task_id';
  static final task_id = 'task_id';
  static final tasks_name = 'tasks_name';
  static final tasks_description = 'tasks_description';
  static final tasks_startDate = 'tasks_start_date';
  static final tasks_endDate = 'tasks_end_date';
  static final tasks_assigned_peoples = 'tasks_assigned_peoples';

  static final subtasks_columnId = 'column_subtasks_id';
  static final subtasks_name = 'subtasks_name';
  static final subtasks_description = 'subtasks_description';
  static final subtasks_startDate = 'subtasks_start_date';
  static final subtasks_endDate = 'subtasks_end_date';
  static final subtasks_assigned_peoples = 'subtasks_assigned_peoples';

  // static Future<void> createTableProject(sql.Database database) async {
  //
  // }

  // static Future<void> createTableTask(sql.Database database) async{
  //   await database.execute('''
  //   CREATE TABLE IF NOT EXIST $task_table(
  //   $tasks_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //   $task_id INTEGER,
  //   $tasks_name TEXT,
  //   $tasks_description TEXT,
  //   $tasks_endDate TEXT,
  //   $tasks_assigned_peoples TEXT,
  //   FOREIGN KEY($task_id) REFERENCES $project_table($project_columnId),
  //   createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  //   )
  //   ''');
  // }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
        '$_databaseName',
        version: _databaseVersion,
        onCreate:  (sql.Database database, int version) async {
          await createTableProject(database);
          print('project table created');
          await createTableTask(database);
          print('task table created');
          await createTableSubTask(database);
          print('sub task table created');
    },
    );
  }

  static Future<void> createTableProject(sql.Database database) async{
    await database.execute('''
    CREATE TABLE $project_table(
    $project_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $project_name TEXT,
    $project_description TEXT,
    $project_startDate TEXT,
    $project_endDate TEXT,
    $project_assigned_peoples TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''');
  }
  static Future<void> createTableTask(sql.Database database) async{
    await database.execute('''
    CREATE TABLE $task_table(
    $tasks_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $tasks_name TEXT,
    $tasks_description TEXT,
    $tasks_endDate TEXT,
    $tasks_assigned_peoples TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    task_id INTEGER NOT NULL, 
    FOREIGN KEY (task_id) REFERENCES tb_project (project_id)
    
    )
    ''');
  }
  static Future<void> createTableSubTask(sql.Database database) async{
    await database.execute('''
    CREATE TABLE $sub_task_table(
    $subtasks_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $subtasks_name TEXT,
    $subtasks_description TEXT,
    $subtasks_endDate TEXT,
    $subtasks_assigned_peoples TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''');
  }

  static Future<int> createProject(String p_name,
      String p_description,
      String s_date,
      String e_date,
      String a_peoples,
      String current_date) async {
    final db = await SQLHelper.db();

    final data = {
      'project_name': p_name,
      'project_description': p_description,
      'project_start_date': s_date,
      'project_end_date': e_date,
      'project_assigned_peoples': a_peoples,
      'createdAt': current_date,
    };
    final id = await db.insert(project_table, data);
    print('project inserted');
    return id;
  }

  static Future<int> createTask(String task_name,
      String task_description,
      String end_date,
      String assign_peoples,
      String current_date) async {
    final db = await SQLHelper.db();

    final data = {
      'tasks_name' : task_name,
      'tasks_description' : task_description,
      'tasks_end_date' : end_date,
      'tasks_assigned_peoples' : assign_peoples,
      'createdAt' : current_date,
    };
    final id = await db.insert(task_table, data);
    print('task inserted');
    return id;
  }

  static Future<List<Map<String, dynamic>>> getProjects() async {
    final db = await SQLHelper.db();
    return db.query(project_table, orderBy: 'project_id');
  }

  static Future<List<Map<String, dynamic>>> getProject(int id) async {
    final db = await SQLHelper.db();
    return db.query(
        project_table, where: 'project_id = ?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await SQLHelper.db();
    return db.query(task_table, orderBy: 'column_task_id');
  }


  static Future<List<Map<String, dynamic>>> getAllTasksByProject(int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM $task_table 
    WHERE $task_id = $id
    ''');
  }



  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await SQLHelper.db();
    return db.query(
        task_table, where: 'column_task_id = ?', whereArgs: [id]);
  }

  static Future<int> updateItem(int id,
      String p_name,
      String p_description,
      String s_date,
      String e_date,
      String a_peoples,
      String current_date) async {
    final db = await SQLHelper.db();
    final data = {
      'project_name': p_name,
      'project_description': p_description,
      'project_start_date': s_date,
      'project_end_date': e_date,
      'project_assigned_peoples': a_peoples,
      'createdAt': current_date,
    };

    final result = await db.update(
        project_table, data, where: 'project_id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(project_table, where: 'project_id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }
}