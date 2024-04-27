import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart'; // Import ToDo model class
import 'package:todolist/widgets/todo_items.dart'; // Import ToDoItem widget
// Enumeration to represent different task categories
enum TaskCategory {
  all,
  completed,
  pending,
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<ToDo> todosList = ToDo.todoList(); // List of all tasks
  List<ToDo> _foundToDo = []; // List of tasks to display based on category
  TaskCategory _selectedCategory = TaskCategory.all; // Default selected category

  @override
  void initState() {
    _updateTasks(); // Initialize tasks based on selected category
    super.initState();
  }

  // Method to update the displayed tasks based on selected category
  void _updateTasks() {
    setState(() {
      switch (_selectedCategory) {
        case TaskCategory.all:
          _foundToDo = todosList; // Display all tasks
          break;
        case TaskCategory.completed:
          _foundToDo = todosList.where((todo) => todo.isDone).toList(); // Display completed tasks
          break;
        case TaskCategory.pending:
          _foundToDo = todosList.where((todo) => !todo.isDone).toList(); // Display pending tasks
          break;
      }
    });
  }

  // Method to handle task completion status change
  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone; // Toggle completion status
      _updateTasks(); // Update displayed tasks after status change
    });
  }

  // Method to handle task deletion
  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id); // Remove task from list
      _updateTasks(); // Update displayed tasks after deletion
    });
  }

  // Method to show dialog for adding a new task
  Future<void> _showAddTaskDialog(BuildContext context) async {
    String newTaskText = ''; // Text entered by the user for the new task

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Task',
          style: TextStyle(fontFamily: 'OoohBaby', fontSize: 55),
          ),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTaskText = value; // Update newTaskText as the user types
            },
            decoration: InputDecoration(hintText: 'Enter task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add the new task to the list and update the tasks
                _addNewTask(newTaskText);
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Method to add a new task to the list
  void _addNewTask(String taskText) {
    if (taskText.isNotEmpty) {
      // Generate a unique ID for the new task (you may use a different approach for IDs)
      String newTaskId = UniqueKey().toString();

      // Create a new ToDo object for the new task
      ToDo newTask = ToDo(
        id: newTaskId,
        todoText: taskText,
        isDone: false,
      );

      // Add the new task to the todosList
      setState(() {
        todosList.add(newTask);
        _updateTasks(); // Update the displayed tasks list
      });
    }
  }

  // Method to set the selected task category
  void _setSelectedCategory(TaskCategory category, BuildContext context) {
    setState(() {
      _selectedCategory = category; // Update selected category
      _updateTasks(); // Update displayed tasks based on new category
    });

    // Close the drawer and navigate to the tasks screen
    Navigator.pop(context); // Close the drawer
  }

  void _handleLogout(BuildContext context) async {
  // Show confirmation dialog
  final shouldLogout = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Logout Confirmation',
      style: TextStyle(fontFamily: 'OoohBaby', fontSize: 55),),
      content: Text('Are you sure you want to logout?'),
      
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false), // Cancel
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true), // Logout
          child: Text('Logout'),
        ),
      ],
    ),
  );

  if (shouldLogout == true) {
    print('User logged out');
  }
}

//Show help
void _showHelpPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Help',
      style: TextStyle(fontFamily: 'OoohBaby', fontSize: 55),),
      content: Text(
        'This is a to-do list app that helps you manage your tasks. \n\n - Use the drawer menu to switch between task categories (All, Completed, Pending).\n - Tap on a task to mark it as completed.\n - Tap on the delete icon to delete it.\n - Tap the floating action button to add a new task.\n - Use the search bar to filter tasks by keyword (Still in progress).',
      style: TextStyle(fontFamily: 'OoohBaby', fontSize: 25),),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Icon(Icons.assignment),
            ),
            SizedBox(width: 8),
            Text(
              ' Hamisi\'s To-do list ',
              style: TextStyle(color: Colors.white,
              fontFamily: 'OoohBaby', fontSize: 25,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF074A88),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/plp.jpeg"),
              ),
              accountName: Text("Hamisi"),
              accountEmail: Text("hamisiplp@gmail.com"),
            ),
            // Drawer menu items for different task categories
            ListTile(
              title: Text("All Tasks"),
              leading: Icon(Icons.menu_outlined),
              onTap: () => _setSelectedCategory(TaskCategory.all, context),
            ),
            ListTile(
              title: Text("Completed Tasks"),
              leading: Icon(Icons.check_box),
              onTap: () => _setSelectedCategory(TaskCategory.completed, context),
            ),
            ListTile(
              title: Text("Pending Tasks"),
              leading: Icon(Icons.incomplete_circle),
              onTap: () => _setSelectedCategory(TaskCategory.pending, context),
            ),
            ListTile(
              title: Text("Help"),
              leading: Icon(Icons.help_center),
              onTap: () => _showHelpPopup(context),
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () => _handleLogout(context),
            ),
            ListTile(
              title: Text("Quote",style: TextStyle(fontFamily: 'OoohBaby', fontSize: 21, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0), // Add some vertical padding
                child: Text(
                  "\“Goals are the fuel in the furnace of achievement.\” \n– Brian Tracy",
                  style: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'OoohBaby', fontSize: 20, fontWeight: FontWeight.bold), // Optional: Italicize the quote
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Search bar for filtering tasks (optional)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color.fromARGB(160, 157, 210, 222),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
              onChanged: (keyword) {
                // Filter the todosList based on the keyword
                _foundToDo = todosList.where((todo) => todo.todoText.toLowerCase().contains(keyword.toLowerCase())).toList();
                // Rebuild the list view to display filtered tasks
                setState(() {});
              },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 20,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 20, minWidth: 25),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _foundToDo.length,
                itemBuilder: (context, index) => ToDoItem(
                  todo: _foundToDo[index],
                  onToDoChanged: _handleToDoChange,
                  onDeleteItem: _deleteToDoItem,
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the dialog to add a new task
          _showAddTaskDialog(context);
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ),
      backgroundColor: const Color(0xFFCECAB7),
    );
  }
}
