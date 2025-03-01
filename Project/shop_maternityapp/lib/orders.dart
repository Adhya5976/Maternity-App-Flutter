import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingManagementPage extends StatefulWidget {
  const BookingManagementPage({super.key});

  @override
  State<BookingManagementPage> createState() => _BookingManagementPageState();
}

class _BookingManagementPageState extends State<BookingManagementPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'customerName': 'Emma Johnson',
      'service': 'Maternity Photoshoot',
      'date': DateTime.now().add(Duration(days: 2)),
      'time': '10:00 AM',
      'duration': '1 hour',
      'status': 'Confirmed',
      'notes': 'Customer prefers outdoor setting',
      'phone': '+1 (555) 123-4567',
      'email': 'emma.j@example.com',
    },
    {
      'id': '2',
      'customerName': 'Sophia Williams',
      'service': 'Prenatal Consultation',
      'date': DateTime.now().add(Duration(days: 3)),
      'time': '2:30 PM',
      'duration': '45 minutes',
      'status': 'Pending',
      'notes': 'First-time mother, has questions about maternity clothing',
      'phone': '+1 (555) 234-5678',
      'email': 'sophia.w@example.com',
    },
    {
      'id': '3',
      'customerName': 'Olivia Brown',
      'service': 'Product Fitting',
      'date': DateTime.now().add(Duration(days: 5)),
      'time': '11:15 AM',
      'duration': '30 minutes',
      'status': 'Confirmed',
      'notes': 'Looking for maternity support belt',
      'phone': '+1 (555) 345-6789',
      'email': 'olivia.b@example.com',
    },
    {
      'id': '4',
      'customerName': 'Ava Miller',
      'service': 'Nutrition Consultation',
      'date': DateTime.now().add(Duration(days: 7)),
      'time': '3:00 PM',
      'duration': '1 hour',
      'status': 'Cancelled',
      'notes': 'Cancelled due to illness',
      'phone': '+1 (555) 456-7890',
      'email': 'ava.m@example.com',
    },
  ];
  
  List<Map<String, dynamic>> get _filteredBookings {
    if (_selectedDay == null) return _bookings;
    
    return _bookings.where((booking) {
      return isSameDay(booking['date'], _selectedDay);
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 250),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking Management",
                  style: GoogleFonts.sanchez(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddBookingDialog(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Booking"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 198, 176, 249),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Calendar and Bookings
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            eventLoader: (day) {
                              return _bookings
                                  .where((booking) => isSameDay(booking['date'], day))
                                  .toList();
                            },
                            calendarStyle: CalendarStyle(
                              markerDecoration: BoxDecoration(
                                color: Color.fromARGB(255, 198, 176, 249),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Color.fromARGB(255, 198, 176, 249),
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Color.fromARGB(255, 198, 176, 249).withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: true,
                              titleCentered: true,
                              formatButtonShowsNext: false,
                              formatButtonDecoration: BoxDecoration(
                                color: Color.fromARGB(255, 198, 176, 249).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              formatButtonTextStyle: TextStyle(
                                color: Color.fromARGB(255, 198, 176, 249),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Booking Legend",
                            style: GoogleFonts.sanchez(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildLegendItem("Confirmed", Colors.green),
                              _buildLegendItem("Pending", Colors.orange),
                              _buildLegendItem("Cancelled", Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  
                  // Bookings List
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDay == null
                                ? "All Bookings"
                                : "Bookings for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                            style: GoogleFonts.sanchez(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: _filteredBookings.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_busy,
                                          size: 60,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "No bookings found for this day",
                                          style: GoogleFonts.sanchez(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _filteredBookings.length,
                                    separatorBuilder: (context, index) => Divider(),
                                    itemBuilder: (context, index) {
                                      final booking = _filteredBookings[index];
                                      return _buildBookingCard(booking);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.sanchez(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
  
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    switch (booking['status']) {
      case 'Confirmed':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['customerName'],
                        style: GoogleFonts.sanchez(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        booking['service'],
                        style: GoogleFonts.sanchez(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    booking['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 5),
                Text(
                  "${booking['date'].day}/${booking['date'].month}/${booking['date'].year}",
                  style: GoogleFonts.sanchez(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 15),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 5),
                Text(
                  "${booking['time']} (${booking['duration']})",
                  style: GoogleFonts.sanchez(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (booking['notes'] != null && booking['notes'].isNotEmpty) ...[
              Text(
                "Notes:",
                style: GoogleFonts.sanchez(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                booking['notes'],
                style: GoogleFonts.sanchez(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10),
            ],
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                SizedBox(width: 5),
                Text(
                  booking['phone'],
                  style: GoogleFonts.sanchez(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 15),
                Icon(Icons.email, size: 16, color: Colors.grey[600]),
                SizedBox(width: 5),
                Text(
                  booking['email'],
                  style: GoogleFonts.sanchez(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    _showEditBookingDialog(context, booking);
                  },
                  icon: Icon(Icons.edit, size: 16),
                  label: Text("Edit"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  ),
                ),
                SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    _showCancelBookingDialog(context, booking);
                  },
                  icon: Icon(Icons.cancel, size: 16),
                  label: Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddBookingDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _serviceController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();
    final _notesController = TextEditingController();
    DateTime _bookingDate = DateTime.now();
    String _bookingTime = '10:00 AM';
    String _duration = '30 minutes';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Booking"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Customer Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _serviceController,
                  decoration: InputDecoration(
                    labelText: "Service",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _bookingDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _bookingDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_bookingDate.day}/${_bookingDate.month}/${_bookingDate.year}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _bookingTime,
                  decoration: InputDecoration(
                    labelText: "Time",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '9:00 AM',
                    '9:30 AM',
                    '10:00 AM',
                    '10:30 AM',
                    '11:00 AM',
                    '11:30 AM',
                    '1:00 PM',
                    '1:30 PM',
                    '2:00 PM',
                    '2:30 PM',
                    '3:00 PM',
                    '3:30 PM',
                    '4:00 PM',
                    '4:30 PM',
                  ]
                      .map((time) => DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _bookingTime = value!;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _duration,
                  decoration: InputDecoration(
                    labelText: "Duration",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '15 minutes',
                    '30 minutes',
                    '45 minutes',
                    '1 hour',
                    '1.5 hours',
                    '2 hours',
                  ]
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _duration = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Add booking logic would go here
                setState(() {
                  _bookings.add({
                    'id': (_bookings.length + 1).toString(),
                    'customerName': _nameController.text,
                    'service': _serviceController.text,
                    'date': _bookingDate,
                    'time': _bookingTime,
                    'duration': _duration,
                    'status': 'Pending',
                    'notes': _notesController.text,
                    'phone': _phoneController.text,
                    'email': _emailController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text("Add Booking"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 198, 176, 249),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showEditBookingDialog(BuildContext context, Map<String, dynamic> booking) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: booking['customerName']);
    final _serviceController = TextEditingController(text: booking['service']);
    final _phoneController = TextEditingController(text: booking['phone']);
    final _emailController = TextEditingController(text: booking['email']);
    final _notesController = TextEditingController(text: booking['notes']);
    DateTime _bookingDate = booking['date'];
    String _bookingTime = booking['time'];
    String _duration = booking['duration'];
    String _status = booking['status'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Booking"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Customer Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _serviceController,
                  decoration: InputDecoration(
                    labelText: "Service",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter service';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _bookingDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _bookingDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_bookingDate.day}/${_bookingDate.month}/${_bookingDate.year}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _bookingTime,
                  decoration: InputDecoration(
                    labelText: "Time",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '9:00 AM',
                    '9:30 AM',
                    '10:00 AM',
                    '10:30 AM',
                    '11:00 AM',
                    '11:30 AM',
                    '1:00 PM',
                    '1:30 PM',
                    '2:00 PM',
                    '2:30 PM',
                    '3:00 PM',
                    '3:30 PM',
                    '4:00 PM',
                    '4:30 PM',
                  ]
                      .map((time) => DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _bookingTime = value!;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _duration,
                  decoration: InputDecoration(
                    labelText: "Duration",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    '15 minutes',
                    '30 minutes',
                    '45 minutes',
                    '1 hour',
                    '1.5 hours',
                    '2 hours',
                  ]
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _duration = value!;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Confirmed',
                    'Pending',
                    'Cancelled',
                  ]
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _status = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Update booking logic would go here
                setState(() {
                  final index = _bookings.indexWhere((b) => b['id'] == booking['id']);
                  if (index != -1) {
                    _bookings[index] = {
                      'id': booking['id'],
                      'customerName': _nameController.text,
                      'service': _serviceController.text,
                      'date': _bookingDate,
                      'time': _bookingTime,
                      'duration': _duration,
                      'status': _status,
                      'notes': _notesController.text,
                      'phone': _phoneController.text,
                      'email': _emailController.text,
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text("Save Changes"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 198, 176, 249),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCancelBookingDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cancel Booking"),
        content: Text("Are you sure you want to cancel the booking for ${booking['customerName']}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = _bookings.indexWhere((b) => b['id'] == booking['id']);
                if (index != -1) {
                  _bookings[index]['status'] = 'Cancelled';
                }
              });
              Navigator.pop(context);
            },
            child: Text("Yes, Cancel"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}