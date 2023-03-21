import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static final _databaseName = "db_project.db";
  static final _databaseVersion = 1;

  static final project_table = 'tb_project';
  static final task_table = 'tb_task';
  static final sub_task_table = 'tb_sub_task';
  static final members_table = 'tb_members';

  static final members_columnId = 'members_id';
  static final members_name = 'members_name';
  static final members_phone = 'members_phone';
  static final members_role = 'members_role';

  static final project_columnId = 'project_id';
  static final project_name = 'project_name';
  static final project_description = 'project_description';
  static final project_startDate = 'project_start_date';
  static final project_endDate = 'project_end_date';
  static final project_assigned_peoples = 'project_assigned_peoples';
  static final project_progress = "project_progress";
  static final project_milestone = "project_milestone";

  static final tasks_columnId = 'column_task_id';
  static final task_id = 'task_id';
  static final tasks_name = 'tasks_name';
  static final tasks_description = 'tasks_description';
  static final tasks_endDate = 'tasks_end_date';
  static final tasks_assigned_peoples = 'tasks_assigned_peoples';
  static final tasks_isEnable = "is_enable_tasks";
  static final tasks_progress = "tasks_progress";
  static final tasks_milestone = "tasks_milestone";
  static final tasks_counter = "tasks_counter";

  static final subtasks_columnId = 'column_subtasks_id';
  static final subtasks_name = 'subtasks_name';
  static final subtasks_description = 'subtasks_description';
  static final subtasks_endDate = 'subtasks_end_date';
  static final subtasks_assigned_peoples = 'subtasks_assigned_peoples';
  static final subtasks_isEnable = "is_enable_subtasks";
  static final subtasks_progress = "subtasks_progress";
  static final subtasks_counter = "subtasks_counter";

  // main method for database in this method database is opened and all tables is created
  static Future<sql.Database> db() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return sql.openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (sql.Database database, int version) async {
        await createTableProject(database);
        print('project table created');
        await createTableTask(database);
        print('task table created');
        await createTableSubTask(database);
        print('sub task table created');
        await createTableMembers(database);
        print('members table created');
      },
    );
  }

  // this method is used to create project table in database
  static Future<void> createTableProject(sql.Database database) async {
    await database.execute('''
    CREATE TABLE $project_table(
    $project_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $project_name TEXT,
    $project_description TEXT,
    $project_startDate TEXT,
    $project_endDate TEXT,
    $project_assigned_peoples TEXT,
    $project_progress REAL,
    $project_milestone INTEGER,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''');
  }

  // this method is used to create task table in database
  static Future<void> createTableTask(sql.Database database) async {
    await database.execute('''
    CREATE TABLE $task_table(
    $tasks_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FK_task_id INTEGER NOT NULL,
    $tasks_name TEXT,
    $tasks_description TEXT,
    $tasks_endDate TEXT,
    $tasks_assigned_peoples TEXT,
    $tasks_isEnable INTEGER,
    $tasks_progress REAL,
    $tasks_milestone INTEGER,
    $tasks_counter INTEGER,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''');
  }

  // this method is used to craete sub task in database
  static Future<void> createTableSubTask(sql.Database database) async {
    await database.execute('''
    CREATE TABLE $sub_task_table(
    $subtasks_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FK_sub_task_id INTEGER NOT NULL,
    $subtasks_name TEXT,
    $subtasks_description TEXT,
    $subtasks_endDate TEXT,
    $subtasks_assigned_peoples TEXT,
    $subtasks_isEnable INTEGER,
    $subtasks_progress REAL,
    $tasks_counter INTEGER,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''');
  }

  // this method is used to create members table in database
  static Future<void> createTableMembers(sql.Database database) async {
    await database.execute('''
    CREATE TABLE $members_table(
    $members_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $members_name TEXT,
    $members_phone TEXT,
    $members_role TEXT
    );
    ''');
  }

  // insert method of project
  static Future<int> createProject(
      String p_name,
      String p_description,
      String s_date,
      String e_date,
      String a_peoples,
      double project_progress,
      int project_milestone,
      String current_date) async {
    final db = await SQLHelper.db();

    final data = {
      'project_name': p_name,
      'project_description': p_description,
      'project_start_date': s_date,
      'project_end_date': e_date,
      'project_assigned_peoples': a_peoples,
      'project_progress': project_progress,
      'project_milestone': project_milestone,
      'createdAt': current_date,
    };
    final id = await db.insert(project_table, data);
    print('project inserted');
    return id;
  }

  // insert method of tasks
  static Future<int> createTask(
      int tid,
      String task_name,
      String task_description,
      String end_date,
      String assign_peoples,
      int isEnable,
      double task_progress,
      int task_milestone,
      int counter,
      String current_date) async {
    final db = await SQLHelper.db();

    final data = {
      'FK_task_id': tid,
      'tasks_name': task_name,
      'tasks_description': task_description,
      'tasks_end_date': end_date,
      'tasks_assigned_peoples': assign_peoples,
      'is_enable_tasks': isEnable,
      'tasks_progress': task_progress,
      'tasks_milestone': task_milestone,
      'tasks_counter': counter,
      'createdAt': current_date,
    };
    final id = await db.insert(task_table, data);
    print('task inserted');
    return id;
  }

  // insert method of sub tasks
  static Future<int> createSubTask(
      int sub_task_id,
      String subtask_name,
      String subtask_description,
      String end_date,
      String assign_peoples,
      int isEnable,
      double subtasks_progress,
      int counter,
      String current_date) async {
    final db = await SQLHelper.db();

    final data = {
      'FK_sub_task_id': sub_task_id,
      'subtasks_name': subtask_name,
      'subtasks_description': subtask_description,
      'subtasks_end_date': end_date,
      'subtasks_assigned_peoples': assign_peoples,
      'is_enable_subtasks': isEnable,
      'subtasks_progress': subtasks_progress,
      'subtasks_counter': counter,
      'createdAt': current_date,
    };
    final id = await db.insert(sub_task_table, data);
    print('sub task inserted');
    return id;
  }

  // insert method of membbers
  static Future<int> createMembers(
      String m_name, String m_phone, String m_role) async {
    final db = await SQLHelper.db();

    final data = {
      'members_name': m_name,
      'members_phone': m_phone,
      'members_role': m_role,
    };
    final id = await db.insert(members_table, data);
    print('members inserted');
    return id;
  }

  // retriving all project records available in project table
  static Future<List<Map<String, dynamic>>> getProjects() async {
    final db = await SQLHelper.db();
    return db.query(project_table, orderBy: 'project_id');
  }

  // retriving specific project for project details page using project_id
  static Future<List<Map<String, dynamic>>> getProject(int id) async {
    final db = await SQLHelper.db();
    return db.query(project_table,
        where: 'project_id = ?', whereArgs: [id], limit: 1);
  }

  // retriving all tasks under a specific project using project_id used as foreign key
  static Future<List<Map<String, dynamic>>> getAllTasksByProject(int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM tb_task WHERE FK_task_id = $id
    ''');
  }

  // retriving specific task for task details page using task_id
  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final db = await SQLHelper.db();
    return db.query(task_table, where: 'column_task_id = ?', whereArgs: [id]);
  }

  // retriving all sub tasks under a specific task using task_id used as foreign key
  static Future<List<Map<String, dynamic>>> getAllSubTasksByTask(int id) async {
    final db = await SQLHelper.db();
    return await db.rawQuery('''
    SELECT * FROM tb_sub_task WHERE FK_sub_task_id = $id
    ''');
  }

  // retriving specific sub task for sub task details page using subtask_id
  static Future<List<Map<String, dynamic>>> getSubTask(int id) async {
    final db = await SQLHelper.db();
    return db.query(sub_task_table,
        where: 'column_subtasks_id = ?', whereArgs: [id]);
  }

  // retriving all members records available in database
  static Future<List<Map<String, dynamic>>> getMembers() async {
    final db = await SQLHelper.db();
    return db.query(members_table, orderBy: 'members_id');
  }

  // retriving specific member for members details page using member_id
  static Future<List<Map<String, dynamic>>> getMember(int id) async {
    final db = await SQLHelper.db();
    return db.query(members_table,
        where: 'members_id = ?', whereArgs: [id], limit: 1);
  }

  // this function is used for update details in project table using project id
  static Future<int> updateProject(
      int id,
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
    final result = await db
        .update(project_table, data, where: 'project_id = ?', whereArgs: [id]);
    return result;
  }

  // this fuction is used for delete record in project table using project id
  static Future<void> deleteProject(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(project_table, where: 'project_id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  // this function is used for update details in task table using task id
  static Future<int> updateTask(
      int id,
      String u_task_name,
      String u_task_description,
      String u_end_date,
      String u_assign_peoples,
      String u_current_date) async {
    final db = await SQLHelper.db();
    final data = {
      'tasks_name': u_task_name,
      'tasks_description': u_task_description,
      'tasks_end_date': u_end_date,
      'tasks_assigned_peoples': u_assign_peoples,
      'createdAt': u_current_date,
    };
    final result = await db
        .update(task_table, data, where: 'column_task_id = ?', whereArgs: [id]);
    return result;
  }

  // this function is used for delete details in task table using task id
  static Future<void> deleteTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(task_table, where: 'column_task_id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  // this function is used for update details in sub task table using subtask id
  static Future<int> updateSubTask(
      int id,
      String u_subtask_name,
      String u_subtask_description,
      String u_end_date,
      String u_assign_peoples,
      String u_current_date) async {
    final db = await SQLHelper.db();
    final data = {
      'subtasks_name': u_subtask_name,
      'subtasks_description': u_subtask_description,
      'subtasks_end_date': u_end_date,
      'subtasks_assigned_peoples': u_assign_peoples,
      'createdAt': u_current_date,
    };
    final result = await db.update(sub_task_table, data,
        where: 'column_subtasks_id = ?', whereArgs: [id]);
    return result;
  }

  // this function is used for delete details in subtask table using subtask id
  static Future<void> deleteSubTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(sub_task_table,
          where: 'column_subtasks_id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }

  /*this method is used for update progress of project
  it update two value one for progress bar and another is for milestone*/
  static Future<int> updateProgressProject(
      int id, double task_progress, int milestone) async {
    final db = await SQLHelper.db();
    final data = {
      'project_progress': task_progress,
      'project_milestone': milestone,
    };
    final result = await db
        .update(project_table, data, where: 'project_id = ?', whereArgs: [id]);
    return result;
  }

  /* this method is used for change values for task table which helps set enable disable
  property to task
  * */
  static Future<int> changeValuesTask(
    int id,
    int isEnable,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'is_enable_tasks': isEnable,
    };
    final result = await db
        .update(task_table, data, where: 'column_task_id = ?', whereArgs: [id]);
    return result;
  }

  /*this method is used for update progress of task
  it update two value one for progress bar and another is for milestone*/
  static Future<int> updateProgressTask(
      int id, double task_progress, int milestone) async {
    final db = await SQLHelper.db();
    final data = {
      'tasks_progress': task_progress,
      'tasks_milestone': milestone,
    };
    final result = await db
        .update(task_table, data, where: 'column_task_id = ?', whereArgs: [id]);
    return result;
  }

  /* this method is used for change values for subtask table which helps set enable disable
  property to subtask
  * */
  static Future<int> changeValuesSubTask(
    int id,
    int isEnable,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'is_enable_subtasks': isEnable,
    };
    final result = await db.update(sub_task_table, data,
        where: 'column_subtasks_id = ?', whereArgs: [id]);
    return result;
  }

  //this method is used to update details of members table using member id
  static Future<int> updateMembers(
      int id, String m_name, String m_phone, String m_role) async {
    final db = await SQLHelper.db();
    final data = {
      'members_name': m_name,
      'members_phone': m_phone,
      'members_role': m_role,
    };
    final result = await db
        .update(members_table, data, where: 'members_id = ?', whereArgs: [id]);
    return result;
  }

  // this method is used for delete member using member id
  static Future<void> deleteMembers(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(members_table, where: 'members_id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('$err');
    }
  }
}
