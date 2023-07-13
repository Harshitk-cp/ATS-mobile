import 'dart:convert';
import 'package:ats_mobile/api/api_response.dart';
import 'package:ats_mobile/api/http_service.dart';
import 'package:ats_mobile/models/applications/all_applications_response.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/models/jobs/job_detail_response.dart';
import 'package:ats_mobile/utility/constants.dart';
import 'package:ats_mobile/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({Key? key}) : super(key: key);

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HttpService httpService = HttpService();
  late ApiResponse _apiResponseAllApplications = ApiResponse();
  late LoginResponse user = LoginResponse();
  late AllApplicationsResponse applicationListResponse =
      AllApplicationsResponse();
  late List<Map<String, dynamic>> applicationList = [];
  late Map<String, JobDetailResponse?> jobDetailsMap = {};

  @override
  void initState() {
    super.initState();
    _getUser();
    _getAllApplications();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 10),
              const Text(
                "My Applications",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Center(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _getAllApplications(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return _buildEmptyApplicationsContainer();
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final jobId = snapshot.data![index]['jobId'];
                                  return FutureBuilder<JobDetailResponse?>(
                                    future: _getJobDetail(jobId),
                                    builder: (context, snapshotJob) {
                                      if (snapshotJob.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshotJob.hasError) {
                                        return const Text(
                                          'Failed to load application details',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        );
                                      } else if (snapshotJob.hasData &&
                                          snapshotJob.data != null) {
                                        final jobDetail = snapshotJob.data!;
                                        return _buildApplicationContainer(
                                          jobDetail: jobDetail,
                                          applicationData:
                                              snapshot.data![index],
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          } else if (snapshot.hasError) {
                            return const Text(
                                "Couldn't load your applications");
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyApplicationsContainer() {
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
        "Seems like you have not applied to any jobs yet.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApplicationContainer({
    required JobDetailResponse jobDetail,
    required Map<String, dynamic> applicationData,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF144c83),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jobDetail.data!.title.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              applicationData['status'] ?? '',
              style: const TextStyle(
                color: Color(0xFF144c83),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Applied on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(applicationData['createdAt']))}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last Updated: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(applicationData['updatedAt']))}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/jobDetail',
                arguments: jobDetail.data!.toJson(),
              );
            },
            child: Container(
              height: 30.0,
              width: 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2a4d74),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(4.0, 2.0),
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Go to Job Details",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2a4d74),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 25,
                      color: Color(0xFF144c83),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          LinearPercentIndicator(
            animation: true,
            lineHeight: 20.0,
            animationDuration: 1000,
            percent: (applicationData['currentRound'] as num) /
                (jobDetail.data?.noOfRounds as num),
            center: Text(
              "${(applicationData['currentRound'] ?? 0) * 100 / (jobDetail.data?.noOfRounds ?? 1)}%",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.grey,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getAllApplications() async {
    if (applicationList.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uniqueId = prefs.getString(SharedPreferencesConstants.UNIQUE_ID)!;
      final auth = prefs.getString(SharedPreferencesConstants.TOKEN)!;
      _apiResponseAllApplications =
          await httpService.getAllApplications(uniqueId, auth);

      setState(() {
        applicationListResponse =
            (_apiResponseAllApplications.Data as AllApplicationsResponse);
      });

      if (applicationListResponse.success == true) {
        final response = applicationListResponse.toJson();

        final List<Map<String, dynamic>> result = [];

        for (var val in response['data']) {
          result.add(val);
        }

        setState(() {
          applicationList = result;
        });
        return result;
      } else {
        Utility.showSnack('An Error Occurred ', _scaffoldKey);
        throw Exception("Failed to load data");
      }
    } else {
      return applicationList;
    }
  }

  Future<JobDetailResponse?> _getJobDetail(jobId) async {
    if (!jobDetailsMap.containsKey(jobId)) {
      final apiResponseJobDetail = await httpService.getJobDetail(jobId);
      final jobDetailResponse =
          (apiResponseJobDetail.Data as JobDetailResponse);

      if (jobDetailResponse.success == true) {
        jobDetailsMap[jobId] = jobDetailResponse;
      }
      return jobDetailsMap[jobId];
    } else {
      return jobDetailsMap[jobId];
    }
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = LoginResponse.fromJson(
      jsonDecode(prefs.getString(SharedPreferencesConstants.USER)!),
    );
  }
}
