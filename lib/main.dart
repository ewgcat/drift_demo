import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:drift_demo/my_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drift Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Drift Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> tasks = <Task>[];
  int current = 0;

  @override
  void initState() {
    super.initState();
    add();
  }

  Future<void> add() async {
    try {
        await DatabaseManager.instance.myDatabase
            .into(DatabaseManager.instance.myDatabase.tasks)
            .insert(TasksCompanion.insert(name: "任务$current"));
        current = current + 1;
      var list = await DatabaseManager.instance.myDatabase.queryTasks();
      tasks = list;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> delete(int i) async {
    await DatabaseManager.instance.myDatabase.deleteTask(tasks[i]);
    tasks.removeAt(i);
    current = current - 1;
    setState(() {});
  }
  Future<void> clear() async {
    await DatabaseManager.instance.myDatabase.deleteAllTasks();
    tasks.clear();
    current = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        DriftDbViewer(DatabaseManager.instance.myDatabase)));
              },
              child: const Text('查看数据库')),
          ElevatedButton(
              onPressed: () {
                add();
              },
              child: const Text('插入1条数据')),
          ElevatedButton(
              onPressed: () {
                clear();
              },
              child: const Text('清空数据')),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                    child: ElevatedButton(
                        onPressed: () {
                          delete(index);
                        },
                        child: Text(
                          '删除${tasks[index].name}',
                        )));
              },
              itemCount: tasks.length,
            ),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
