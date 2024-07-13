import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/bloc/todo_bloc.dart';
import 'package:todo/data/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add todo
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  // remove todo
  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  // alter todo
  alterTodo(int index) {
    context.read<TodoBloc>().add(
          AlterTodo(index),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller1 = TextEditingController();
                TextEditingController controller2 = TextEditingController();

                return AlertDialog(
                  title: Text("Add a task"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: "Task Title...",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: controller2,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: "Task Description...",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ))),
                      )
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextButton(
                        onPressed: () {
                          addTodo(Todo(
                              title: controller1.text,
                              subtitle: controller2.text));
                          controller1.text = '';
                          controller2.text = '';
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Add Task",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My TODO",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (_) {
                            removeTodo(state.todos[i]);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ]),
                      child: ListTile(
                        title: Text(state.todos[i].title),
                        subtitle: Text(state.todos[i].subtitle),
                        trailing: Checkbox(
                          onChanged: (value) {
                            alterTodo(i);
                          },
                          value: state.todos[i].isDone,
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
