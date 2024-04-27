<h1>To-Do List Flutter Application</h1>
This Flutter application is designed to manage tasks efficiently using three major folders that play key roles in building the user interface:

<h3>Folder Structure</h3>
<h4>1. model</h4>
The model folder is responsible for defining the structure of the to-do items:

<h5>To-Do Item Model:</h5>
name: The name of the task that will be displayed.<br>
id: A unique identifier used for functionality like deleting a specific item.<br>
isCompleted: A boolean value indicating whether the task is accomplished.

<h4>2. screens</h4>
The screens folder handles the UI views of the application, containing all the widgets used throughout:

<h5>Task List Screen:</h5>
Displays the list of tasks with checkboxes and delete icons for each task.
<h5>Add Task Screen:</h5>
Allows users to add new tasks with input fields for task name.
3. widgets
The widgets folder contains reusable components that control the elements inside the task container:

<h5>Task Widget:</h5>
Manages the layout and behavior of individual tasks displayed in the list.
Includes a checkbox to mark task completion and an icon for deleting the task.
<h5>Features</h5>
Task Management:
<br><br>
Add, edit, and delete tasks.<br>
Mark tasks as completed or pending.<br>
<h4>Folder Descriptions</h4>
<h5>model</h5>
This folder defines the data structure for the to-do items used in the application.

<h5>screens</h5>
Screens are responsible for rendering the user interface of different parts of the app, such as the task list and add task screens.

<h5>widgets</h5>
Widgets are reusable components that encapsulate UI elements and behavior, making it easier to build and maintain the app's interface.

