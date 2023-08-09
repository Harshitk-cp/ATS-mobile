import 'dart:convert';
import 'package:ats_mobile/api/api_response.dart';
import 'package:ats_mobile/api/http_service.dart';
import 'package:ats_mobile/models/applications/all_applications_response.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utility/constants.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key? key}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LoginResponse user = LoginResponse();
  late ApiResponse _apiResponse;
  List<String> list = [];

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic job = ModalRoute.of(context)?.settings.arguments;
    list = job['applicants'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2a4d74),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                job['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  job['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
              jobDetailWidget(job),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget jobDetailWidget(job) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x00032140).withOpacity(0.3),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          )
        ],
        color: const Color(0xFAF9F9F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const SizedBox(width: 25, child: Divider(color: Colors.black, thickness: 3)),
          const SizedBox(height: 10),
          ...[
            _buildListTile(Icons.email, job['email']),
            _buildListTile(Icons.location_on, job['address']),
            _buildListTile(Icons.currency_rupee_rounded, 'Salary Range: ₹${job['salaryRange']}'),
            _buildListTile(Icons.person, 'No. of Positions: ${job['noOfPositions']}'),
            _buildListTile(Icons.school, 'Education: ${job['education']}'),
            _buildListTile(Icons.work, 'Experience: ${job['experience']}'),
            _buildListTile(Icons.playlist_add_check, 'No. of Rounds: ${job['noOfRounds']}'),
            _buildListTile(Icons.work, 'Job Type: ${job['jobType']}'),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _applyJob(job['userId'], job['_id']),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  height: 40.0,
                  padding: const EdgeInsets.only(right: 5),
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(1.0, 2.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      list.contains(user.user?.id.toString()) ? 'Already Applied' : 'Apply',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2a4d74),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  ListTile _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2a4d74)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  void _applyJob(hrId, jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString(SharedPreferencesConstants.UNIQUE_ID)!;
    final auth = prefs.getString(SharedPreferencesConstants.TOKEN)!;
    _apiResponse = await httpService.applyJob(uniqueId, hrId, jobId, auth);

    if ((_apiResponse.Data as AllApplicationsResponse).success == true) {
      Navigator.pushNamed(context, '/applied');
    } else {
      String? str = (_apiResponse.Data as AllApplicationsResponse).message;
      Utility.showSnack(str.toString(), _scaffoldKey);
    }
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = LoginResponse.fromJson(jsonDecode(prefs.getString(SharedPreferencesConstants.USER)!));
    });
  }
}
