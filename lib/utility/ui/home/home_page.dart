import 'dart:convert';

import 'package:ats_mobile/api/api_response.dart';
import 'package:ats_mobile/api/http_service.dart';
import 'package:ats_mobile/models/applications/all_applications_response.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/models/jobs/all_jobs_response.dart';
import 'package:ats_mobile/utility/constants.dart';
import 'package:ats_mobile/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final HttpService httpService = HttpService();
  late LoginResponse user = LoginResponse();
  late ApiResponse _apiResponseAllJobs = ApiResponse();
  late ApiResponse _apiResponseAllApplications = ApiResponse();
  late AllJobsResponse jobsListResponse = AllJobsResponse();
  late AllApplicationsResponse applicationListResponse =
      AllApplicationsResponse();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int jobsListCount = 0;
  late int applicationsCount = 0;
  late int appliedCount = 0;
  late int ongoingCount = 0;
  late int selectedCount = 0;
  late int rejectedCount = 0;
  late List<Map<String, dynamic>> jobsList = [];

  @override
  void initState() {
    _getUser();
    _getAllApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2a4d74),
        body: RefreshIndicator(
          onRefresh: () async {
            jobsList = [];
            await _getAllJobs();
            _getAllApplications();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 20),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            user.user?.name?.substring(0, 1).toUpperCase() ??
                                "",
                            style: TextStyle(
                              fontSize: 20,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Color(0xFF144c83),
                            ),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: "Welcome back,\n"),
                            TextSpan(
                              text: user.user?.name ?? "",
                              style: const TextStyle(
                                color: Color(0xFF9DFFF3),
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/applications');
                  },
                  child: Container(
                    height: 160.0,
                    margin: const EdgeInsets.all(20.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/main_card_bg.png"),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x00032140).withOpacity(0.3),
                          blurRadius: 10.0,
                          spreadRadius: 5.0,
                          offset: Offset(4.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: "Total Applications,\n"),
                              TextSpan(
                                text: applicationsCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(
                            left: 4,
                            right: 5,
                            bottom: 15,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF609BB5).withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(13),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: appliedCount.toString(),
                                    ),
                                    const TextSpan(
                                      text: " applied",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ongoingCount.toString(),
                                    ),
                                    const TextSpan(
                                      text: " ongoing",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x00032140).withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                    color: const Color(0xFAF9F9F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(
                        width: 25,
                        child: Divider(
                          color: Colors.black,
                          thickness: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Jobs you'd like :",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _getAllJobs(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data?.isEmpty ?? true) {
                                // Display "No jobs found" container
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Seems like there's no job available right now.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/jobDetail',
                                          arguments: snapshot.data?[index],
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          30,
                                          10,
                                          20,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF144c83),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 10.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data?[index]
                                                          ['title'] ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  snapshot.data?[index]
                                                              ['salaryRange']
                                                          .toString() ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 5,
                                              ),
                                              decoration: const ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(7),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                snapshot.data?[index]['tags'] ??
                                                    '',
                                                style: const TextStyle(
                                                  color: Color(0xFF144c83),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              snapshot.data?[index]
                                                      ['description'] ??
                                                  '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Email: ${snapshot.data?[index]['email'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Address: ${snapshot.data?[index]['address'] ?? ''}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Posted on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data?[index]['createdAt']))}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            } else if (snapshot.hasError) {
                              return const SizedBox(height: 5);
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getAllJobs() async {
    if (jobsList.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final auth = prefs.getString(SharedPreferencesConstants.TOKEN)!;
      _apiResponseAllJobs = await httpService.getAlJobs(auth);

      setState(() {
        jobsListResponse = _apiResponseAllJobs.Data as AllJobsResponse;
      });

      if (jobsListResponse.success == true) {
        final response = jobsListResponse.toJson();

        final List<Map<String, dynamic>> result = [];

        for (var val in response['data']) {
          result.add(val);
        }

        setState(() {
          jobsList = result;
          jobsListCount = result.length;
        });
        return result;
      } else {
        Utility.showSnack(
          '${jobsListResponse.message}',
          _scaffoldKey,
        );
        throw Exception("Failed to load data");
      }
    } else {
      return jobsList;
    }
  }

  void _getAllApplications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uniqueId = prefs.getString(SharedPreferencesConstants.UNIQUE_ID)!;
    final auth = prefs.getString(SharedPreferencesConstants.TOKEN)!;
    _apiResponseAllApplications =
        await httpService.getAllApplications(uniqueId, auth);

    setState(() {
      applicationListResponse =
          _apiResponseAllApplications.Data as AllApplicationsResponse;
    });

    if (applicationListResponse.success == true) {
      final response = applicationListResponse.toJson();

      final List<Map<String, dynamic>> result = [];

      for (var val in response['data']) {
        result.add(val);
      }

      applicationsCount = result.length;
      appliedCount = result.where((app) => app['status'] == 'Applied').length;
      ongoingCount = result.where((app) => app['status'] == 'ongoing').length;
      selectedCount = result.where((app) => app['status'] == 'hired').length;
      rejectedCount = result.where((app) => app['status'] == 'Rejected').length;
    } else {
      Utility.showSnack('An Error Occurred ', _scaffoldKey);
      throw Exception("Failed to load data");
    }
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = LoginResponse.fromJson(
      jsonDecode(
        prefs.getString(SharedPreferencesConstants.USER)!,
      ),
    );
  }
}
