import 'package:dispensary/common/user_greet.dart';
import 'package:dispensary/providers/dashboard_provider.dart';
import 'package:dispensary/providers/landing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isPendingAmountCalculated = false; // Flag to track calculation

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure calculation is triggered only once when screen is visible
    if (!_isPendingAmountCalculated) {
      _isPendingAmountCalculated = true; // Set flag to prevent multiple calls
      final dashboardProvider = Provider.of<DashboardScreenProvider>(context);
      dashboardProvider.calculateTotalPendingAmountForScheduledPatientsOnTommrow();
      //dashboardProvider.scheduledPatientsTomorrow(100);
      // dashboardProvider.getPatientsCreatedToday();
      //dashboardProvider.getFollowUpPatientsToday();
      //dashboardProvider.scheduledPatientsToday();
      dashboardProvider.updateCounts();
    }
  }

  // Flag to prevent infinite loop
  final ButtonStyle btnStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Adjust the border radius
    ),
    minimumSize: const Size(double.infinity, 50), // Set the minimum width and height
  );

  // DashboardScreenProvider dashboardScreenProvider =
  @override
  Widget build(BuildContext context) {
    debugPrint("Invoking build: dashboard screen");
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<DashboardScreenProvider>(builder: (context, dashboardProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: UserGreet(),
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
                      text: 'Fllow-up',
                      backgroundColor: Colors.black12,
                      value: dashboardProvider.followUpatients.toString(),
                    ),
                    CircleWidget(
                      radius: 50,
                      icon: Icons.schedule,
                      text: 'Scheduled Today',
                      backgroundColor: Colors.black12,
                      value: dashboardProvider.scheduledToday.toString(),
                    ),
                  ],
                  context: context),
              const SizedBox(
                height: 25,
              ),
              // Collection Information
              const Text("Scheduled For Tomorrow", style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 6,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatCard('Pending Bal', dashboardProvider.pendingAmount.toStringAsFixed(1), Icons.currency_rupee, (MediaQuery.of(context).size.width / 2) - 20, context),
                  _buildStatCard('Total Appointments', dashboardProvider.scheduledTomorrow.toString(), Icons.person_2, (MediaQuery.of(context).size.width / 2) - 20, context),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
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
                  ],
                ),
              ),

              // Patient management
              const SizedBox(
                height: 22,
              ),
              // Collection Information
              const Text('Patient Care', style: TextStyle(fontSize: 20)),

              const SizedBox(height: 14),

              Container(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Provider.of<LandingScreenProvider>(context, listen: false).index = 2;
                      },
                      child: const Text("View All Patients"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: btnStyle,
                      onPressed: () {
                        Provider.of<LandingScreenProvider>(context, listen: false).index = 1;
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
                        Provider.of<LandingScreenProvider>(context, listen: false).index = 4;
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: content),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData iconName, double maxWidth, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 13),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconName,
                    size: 50,
                    color: Colors.black12,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Baseline(
                      baseline: 0.0,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        value,
                        style: const TextStyle(overflow: TextOverflow.clip, fontSize: 20),
                      ),
                    ),
                  ),
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
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: list),
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

  CircleWidget({required this.radius, required this.text, required this.backgroundColor, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: backgroundColor, width: 1)),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
