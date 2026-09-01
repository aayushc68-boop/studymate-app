import 'package:flutter/material.dart';

void main() {
  runApp(const StudyMateApp());
}

const Color primaryPurple = Color(0xFF5845EB);
const Color lightPurple = Color(0xFFF6F6FF);
const Color borderPurple = Color(0xFFD9D5FF);
const Color darkText = Color(0xFF151934);

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          primary: primaryPurple,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const StudyMateShell(),
    );
  }
}

class StudyTask {
  StudyTask({
    required this.title,
    required this.time,
    this.subject = '',
    this.priority = 'Medium',
    this.notes = '',
    this.reminder = true,
    this.completed = false,
  });

  final String title;
  final String time;
  final String subject;
  final String priority;
  final String notes;
  final bool reminder;
  bool completed;
}

class StudyMateShell extends StatefulWidget {
  const StudyMateShell({super.key});

  @override
  State<StudyMateShell> createState() => _StudyMateShellState();
}

class _StudyMateShellState extends State<StudyMateShell> {
  int currentScreen = 0;
  int selectedNavigation = 0;
  int previousScreen = 0;
  bool weeklySelected = false;

  final List<StudyTask> tasks = [
    StudyTask(
      title: 'Review UX lecture notes',
      time: '9:00 AM – 9:45 AM',
      completed: true,
    ),
    StudyTask(
      title: 'Work on prototype',
      time: '10:00 AM – 12:00 PM',
    ),
    StudyTask(
      title: 'Prepare research outline',
      time: '4:30 PM – 6:30 PM',
    ),
    StudyTask(
      title: 'Read Forensics Chapter',
      time: '7:00 PM – 8:15 PM',
    ),
  ];

  int get completedTasks =>
      tasks.where((task) => task.completed).length;

  void openAddTask() {
    previousScreen = currentScreen;

    setState(() {
      currentScreen = 2;
    });
  }

  void closeAddTask() {
    setState(() {
      currentScreen = previousScreen;
    });
  }

  void saveNewTask(StudyTask task) {
    setState(() {
      tasks.add(task);
      currentScreen = 1;
      selectedNavigation = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task saved successfully.'),
      ),
    );
  }

  void changeNavigation(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        selectedNavigation = index;
        currentScreen = index;
      });
    } else {
      const names = [
        'Home',
        'Tasks',
        'Calendar',
        'Progress',
        'Profile',
      ];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${names[index]} will be added next.'),
        ),
      );
    }
  }

  void showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name will be added next.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    if (currentScreen == 0) {
      screen = HomePage(
        completedTasks: completedTasks,
        totalTasks: tasks.length,
        onAddTask: openAddTask,
        onOpenTasks: () => changeNavigation(1),
        onCalendar: () => showComingSoon('Calendar'),
        onReminder: () => showComingSoon('Reminder'),
      );
    } else if (currentScreen == 1) {
      screen = TasksPage(
        tasks: tasks,
        weeklySelected: weeklySelected,
        onAddTask: openAddTask,
        onToggleView: (value) {
          setState(() {
            weeklySelected = value;
          });
        },
        onTaskChanged: (task, value) {
          setState(() {
            task.completed = value;
          });
        },
      );
    } else {
      screen = AddTaskPage(
        onBack: closeAddTask,
        onSave: saveNewTask,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(child: screen),
            bottomNavigationBar: currentScreen == 2
                ? null
                : StudyBottomNavigation(
                    selectedIndex: selectedNavigation,
                    onSelected: changeNavigation,
                  ),
          ),
        ),
      ),
    );
  }
}

// HOME PAGE

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.onAddTask,
    required this.onOpenTasks,
    required this.onCalendar,
    required this.onReminder,
  });

  final int completedTasks;
  final int totalTasks;
  final VoidCallback onAddTask;
  final VoidCallback onOpenTasks;
  final VoidCallback onCalendar;
  final VoidCallback onReminder;

  @override
  Widget build(BuildContext context) {
    final double progress =
        totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'StudyMate',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFEDEAFF),
                child: Text(
                  'AC',
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Good morning, Aayush!',
            style: TextStyle(
              color: darkText,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Wednesday, 29 July',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 22),
          ProgressCard(
            completedTasks: completedTasks,
            totalTasks: totalTasks,
            progress: progress,
          ),
          const SizedBox(height: 22),
          const SectionTitle(title: 'Upcoming Tasks'),
          const SizedBox(height: 10),
          HomeTaskCard(
            title: 'UX Wireframe',
            subtitle: 'Due today',
            onPressed: onOpenTasks,
          ),
          const SizedBox(height: 10),
          HomeTaskCard(
            title: 'Business Research',
            subtitle: 'Due 24 July',
            onPressed: onOpenTasks,
          ),
          const SizedBox(height: 10),
          HomeTaskCard(
            title: 'Forensics Lab',
            subtitle: 'Due 26 July',
            onPressed: onOpenTasks,
          ),
          const SizedBox(height: 22),
          const SectionTitle(title: 'Quick Actions'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  icon: Icons.add,
                  label: 'Add Task',
                  onPressed: onAddTask,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.calendar_month_outlined,
                  label: 'Calendar',
                  onPressed: onCalendar,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionButton(
                  icon: Icons.notifications_none,
                  label: 'Reminder',
                  onPressed: onReminder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// MY TASKS PAGE

class TasksPage extends StatelessWidget {
  const TasksPage({
    super.key,
    required this.tasks,
    required this.weeklySelected,
    required this.onAddTask,
    required this.onToggleView,
    required this.onTaskChanged,
  });

  final List<StudyTask> tasks;
  final bool weeklySelected;
  final VoidCallback onAddTask;
  final ValueChanged<bool> onToggleView;
  final void Function(StudyTask, bool) onTaskChanged;

  @override
  Widget build(BuildContext context) {
    final completed =
        tasks.where((task) => task.completed).length;
    final remaining = tasks.length - completed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My Tasks',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onAddTask,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EFF4),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ViewOption(
                    label: 'Daily',
                    selected: !weeklySelected,
                    onPressed: () => onToggleView(false),
                  ),
                ),
                Expanded(
                  child: ViewOption(
                    label: 'Weekly',
                    selected: weeklySelected,
                    onPressed: () => onToggleView(true),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderPurple),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        weeklySelected
                            ? 'This Week'
                            : 'Tuesday',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '$remaining tasks remaining',
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: tasks.isEmpty
                          ? 0
                          : completed / tasks.length,
                      minHeight: 8,
                      backgroundColor:
                          const Color(0xFFE1DFEA),
                      color: primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            weeklySelected ? 'This Week' : 'To Do',
            style: const TextStyle(
              color: darkText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TaskListCard(
                task: task,
                onChanged: (value) {
                  onTaskChanged(task, value);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => onToggleView(true),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: primaryPurple,
                ),
                foregroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Plan This Week',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ADD TASK PAGE

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({
    super.key,
    required this.onBack,
    required this.onSave,
  });

  final VoidCallback onBack;
  final ValueChanged<StudyTask> onSave;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedSubject;
  String selectedPriority = 'Medium';
  bool reminderEnabled = true;

  DateTime selectedDate = DateTime(2026, 7, 31);
  TimeOfDay selectedTime =
      const TimeOfDay(hour: 23, minute: 59);

  final List<String> subjects = [
    'User Experience',
    'Mobile Application',
    'Digital Forensics',
    'Business Research',
    'Other',
  ];

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String dateText(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  String timeText(TimeOfDay time) {
    final hour =
        time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period =
        time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  Future<void> selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  Future<void> selectTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (result != null) {
      setState(() {
        selectedTime = result;
      });
    }
  }

  void saveTask() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    widget.onSave(
      StudyTask(
        title: titleController.text.trim(),
        subject: selectedSubject ?? 'Other',
        priority: selectedPriority,
        reminder: reminderEnabled,
        notes: notesController.text.trim(),
        time:
            '${dateText(selectedDate)} • ${timeText(selectedTime)}',
      ),
    );
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF7A829B),
        fontSize: 13,
      ),
      filled: true,
      fillColor: lightPurple,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: borderPurple,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: primaryPurple,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Add Task',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const FieldLabel(text: 'Task title'),
            const SizedBox(height: 9),
            TextFormField(
              controller: titleController,
              decoration:
                  fieldDecoration('e.g. Finish UX wireframe'),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Please enter a task title';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            const FieldLabel(text: 'Subject'),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              initialValue: selectedSubject,
              isExpanded: true,
              decoration:
                  fieldDecoration('Select a subject'),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a subject';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(text: 'Due date'),
                      const SizedBox(height: 9),
                      TextFormField(
                        readOnly: true,
                        onTap: selectDate,
                        decoration: fieldDecoration(
                          dateText(selectedDate),
                        ).copyWith(
                          suffixIcon: const Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(text: 'Time'),
                      const SizedBox(height: 9),
                      TextFormField(
                        readOnly: true,
                        onTap: selectTime,
                        decoration: fieldDecoration(
                          timeText(selectedTime),
                        ).copyWith(
                          suffixIcon: const Icon(
                            Icons.access_time,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const FieldLabel(text: 'Priority'),
            const SizedBox(height: 10),
            Row(
              children: [
                PriorityButton(
                  label: 'Low',
                  selected:
                      selectedPriority == 'Low',
                  onPressed: () {
                    setState(() {
                      selectedPriority = 'Low';
                    });
                  },
                ),
                const SizedBox(width: 9),
                PriorityButton(
                  label: 'Medium',
                  selected:
                      selectedPriority == 'Medium',
                  onPressed: () {
                    setState(() {
                      selectedPriority = 'Medium';
                    });
                  },
                ),
                const SizedBox(width: 9),
                PriorityButton(
                  label: 'High',
                  selected:
                      selectedPriority == 'High',
                  onPressed: () {
                    setState(() {
                      selectedPriority = 'High';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderPurple),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reminder',
                          style: TextStyle(
                            color: darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Notify one day before',
                          style: TextStyle(
                            color: Color(0xFF70758A),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: reminderEnabled,
                    activeThumbColor: primaryPurple,
                    onChanged: (value) {
                      setState(() {
                        reminderEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const FieldLabel(text: 'Notes'),
            const SizedBox(height: 9),
            TextFormField(
              controller: notesController,
              minLines: 4,
              maxLines: 5,
              decoration: fieldDecoration(
                'Add instructions or notes...',
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: saveTask,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  'Save Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// REUSABLE WIDGETS

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: darkText,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PriorityButton extends StatelessWidget {
  const PriorityButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 47,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                selected ? primaryPurple : lightPurple,
            foregroundColor:
                selected ? Colors.white : darkText,
            side: BorderSide(
              color: selected
                  ? primaryPurple
                  : borderPurple,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class TaskListCard extends StatelessWidget {
  const TaskListCard({
    super.key,
    required this.task,
    required this.onChanged,
  });

  final StudyTask task;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderPurple),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.completed,
            activeColor: primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) {
              onChanged(value ?? false);
            },
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.progress,
  });

  final int completedTasks;
  final int totalTasks;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderPurple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '$completedTasks of $totalTasks tasks completed',
                style: const TextStyle(fontSize: 11),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: primaryPurple,
            backgroundColor: const Color(0xFFE1DFEA),
          ),
        ],
      ),
    );
  }
}

class HomeTaskCard extends StatelessWidget {
  const HomeTaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: lightPurple,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          constraints:
              const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: borderPurple),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  border:
                      Border.all(color: borderPurple),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: lightPurple,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 86,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: borderPurple),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryPurple),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewOption extends StatelessWidget {
  const ViewOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? primaryPurple
          : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color:
                  selected ? Colors.white : darkText,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class StudyBottomNavigation extends StatelessWidget {
  const StudyBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.home_outlined,
      Icons.check_box_outlined,
      Icons.calendar_month_outlined,
      Icons.bar_chart_outlined,
      Icons.person_outline,
    ];

    const selectedIcons = [
      Icons.home,
      Icons.check_box,
      Icons.calendar_month,
      Icons.bar_chart,
      Icons.person,
    ];

    const labels = [
      'Home',
      'Tasks',
      'Calendar',
      'Progress',
      'Profile',
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E3F0)),
        ),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final selected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onSelected(index),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      selected
                          ? selectedIcons[index]
                          : icons[index],
                      color: selected
                          ? primaryPurple
                          : Colors.grey,
                      size: 21,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: selected
                            ? darkText
                            : Colors.grey,
                        fontSize: 9,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: darkText,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}