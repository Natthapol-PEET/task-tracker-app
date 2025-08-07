import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _selectedBoard = 'Ongoing';
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _teamMembers = [
    {'name': 'Jeny', 'avatar': 'assets/images/avatar-1.jpg', 'selected': false},
    {
      'name': 'mehrin',
      'avatar': 'assets/images/avatar-2.jpg',
      'selected': false
    },
    {
      'name': 'Avishek',
      'avatar': 'assets/images/avatar-3.jpg',
      'selected': false
    },
    {
      'name': 'Jafor',
      'avatar': 'assets/images/avatar-4.jpg',
      'selected': false
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 14)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${_getMonthName(_selectedDate.month)} ${_selectedDate.day}, ${_selectedDate.year}';
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _startTimeController.text = _startTime
                      .format(context)
                      .contains('am') ||
                  _startTime.format(context).contains('pm')
              ? _startTime.format(context)
              : '${_startTime.hourOfPeriod}:${_startTime.minute.toString().padLeft(2, '0')} ${_startTime.period == DayPeriod.am ? 'am' : 'pm'}';
        } else {
          _endTime = picked;
          _endTimeController.text = _endTime.format(context).contains('am') ||
                  _endTime.format(context).contains('pm')
              ? _endTime.format(context)
              : '${_endTime.hourOfPeriod}:${_endTime.minute.toString().padLeft(2, '0')} ${_endTime.period == DayPeriod.am ? 'am' : 'pm'}';
        }
      });
    }
  }

  void _toggleTeamMember(int index) {
    setState(() {
      _teamMembers[index]['selected'] = !_teamMembers[index]['selected'];
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      if (_teamMembers.where((member) => member['selected'] == true).isEmpty) {
        showDialog(
          context: context,
          builder: (ctx) {
           return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.purple, size: 28),
          const SizedBox(width: 8),
          Text(
            'Warning',
            style: TextStyle(
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Text(
          'Please select at least one team member',
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
          },
        );

        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name
              const Text(
                'Task Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _textFormField(
                controller: _taskNameController,
                hintText: 'Enter task name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter task name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Team Member
              const Text(
                'Team Member',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._teamMembers.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> member = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _toggleTeamMember(index),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(member['avatar']),
                                ),
                                if (member['selected'])
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            member['name'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  // Add member button
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF6B46C1)),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF6B46C1),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Date
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _textFormField(
                readOnly: true,
                controller: _dateController,
                hintText: 'Select date',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select date";
                  }
                  return null;
                },
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Start Time
                        const Text(
                          'Start Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _textFormField(
                          readOnly: true,
                          controller: _startTimeController,
                          hintText: 'Select time',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select start time";
                            }
                            return null;
                          },
                          onTap: () => _selectTime(context, true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // End Time
                        const Text(
                          'End Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _textFormField(
                          readOnly: true,
                          controller: _endTimeController,
                          hintText: 'Select time',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select end time";
                            }
                            return null;
                          },
                          onTap: () => _selectTime(context, false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Status Section
              const Text(
                'Board',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buttonGroup(text: 'Urgent'),
                  const SizedBox(width: 16),
                  _buttonGroup(text: 'Ongoing'),
                  const SizedBox(width: 16),
                  _buttonGroup(text: 'Running'),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 40),
        child: ElevatedButton(
          onPressed: _saveTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B46C1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _textFormField({
    bool readOnly = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
    required String hintText,
    Function()? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B46C1)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buttonGroup({required String text}) {
    bool isActive = _selectedBoard == text;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedBoard = text),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? const Color(0xFF6B46C1) : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isActive ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
