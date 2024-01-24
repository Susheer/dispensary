import 'package:dispensary/providers/dashboard_provider.dart';
import 'package:dispensary/providers/landing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  ButtonStyle btnStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Adjust the border radius
    ),
    minimumSize:
        const Size(double.infinity, 50), // Set the minimum width and height
  );

  @override
  Widget build(BuildContext context) {
    debugPrint("Invoking build: dashboard screen");
    Provider.of<DashboardScreenProvider>(context, listen: false)
        .getPatientsCreatedToday();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<DashboardScreenProvider>(
            builder: (context, dashboardProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Hi Sudheer, Welcome back!',
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(
                height: 18,
              ),
              buildSection(
                  title: "Today's Statistics",
                  content: [
                    CircleWidget(
                      radius: 50,
                      value: dashboardProvider.newPatients.toString(),
                      text: 'New Patients',
                      icon: Icons.app_registration,
                      backgroundColor: Colors.black12,
                    ),
                    CircleWidget(
                      radius: 50,
                      icon: Icons.receipt_long,
                      text: 'Follow Up',
                      backgroundColor: Colors.black12,
                      value: "5",
                    ),
                    CircleWidget(
                      radius: 50,
                      icon: Icons.schedule,
                      text: 'Scheduled Today',
                      backgroundColor: Colors.black12,
                      value: "100",
                    ),
                  ],
                  context: context),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Pending Amount', '30', Icons.currency_rupee),
                  _buildStatCard('Total Appointments', '30', Icons.person_2),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              // Collection Information
              const Text('Appointment Management',
                  style: TextStyle(fontSize: 20)),

              const SizedBox(height: 14),

              Container(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        // Implement the logic to send reminders
                      },
                      child: const Text("Send Reminder for Tomorrow"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        // Implement the logic to send reminders
                      },
                      child: Text('Pending Payments Tomorrow'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Patient management
              const SizedBox(
                height: 22,
              ),
              // Collection Information
              const Text('Patient Care', style: TextStyle(fontSize: 20)),

              const SizedBox(height: 14),

              Container(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Provider.of<LandingScreenProvider>(context,
                                listen: false)
                            .index = 2;
                      },
                      child: const Text("View All Patients"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Provider.of<LandingScreenProvider>(context,
                                listen: false)
                            .index = 1;
                        // Implement the logic to send reminders
                      },
                      child: const Text('Search Patient'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Provider.of<LandingScreenProvider>(context,
                                listen: false)
                            .index = 4;
                        // Implement the logic to send reminders
                      },
                      child: const Text('Add Patient'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<Widget> content,
    required BuildContext context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: const EdgeInsets.only(top: 17, bottom: 35, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: content),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData iconName) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      child: Card(
        surfaceTintColor: const Color(0xff6750a4),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    iconName,
                    size: 50,
                    color: Colors.black12,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 23,
                          leadingDistribution:
                              TextLeadingDistribution.proportional))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget horizonalScrollBar(List<Widget> list) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list),
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  final double radius;
  final String text;
  final Color backgroundColor;
  final String value;
  final IconData icon;

  CircleWidget(
      {required this.radius,
      required this.text,
      required this.backgroundColor,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: backgroundColor, width: 1)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
