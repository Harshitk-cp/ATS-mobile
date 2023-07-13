import 'dart:convert';
import 'dart:io';
import 'package:ats_mobile/models/applications/all_applications_response.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/models/jobs/all_jobs_response.dart';
import 'package:ats_mobile/models/jobs/job_detail_response.dart';
import 'package:ats_mobile/utility/constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'api_response.dart';

class HttpService {
  final String _baseUrl = ApiConstants.BASE_URL;

  final headers = {
    'Content-Type': 'application/json',
    'Charset': 'utf-8',
    "Connection": "Keep-Alive",
  };

  Future<ApiResponse> login(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res = await post(Uri.parse("$_baseUrl/users/login"),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: headers);

      apiResponse.Data = LoginResponse.fromJson(json.decode(res.body));
    } on SocketException {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }

    return apiResponse;
  }

  Future<ApiResponse> signup(
      String name, email, password, phone, bio, File? resume) async {
    ApiResponse apiResponse = ApiResponse();
    bool isEmployer = false;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/users/signup'),
    );

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['phone'] = phone;
    request.fields['bio'] = bio;
    request.fields['isEmployer'] = isEmployer.toString();

    if (resume != null) {
      String fileName = path.basename(resume.path);
      request.files.add(await http.MultipartFile.fromPath(
        'resume',
        resume.path,
        filename: fileName,
      ));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      apiResponse.Data = LoginResponse.fromJson(json.decode(responseBody));
    } else {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }

    return apiResponse;
  }

  Future<ApiResponse> getAlJobs(auth) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res =
          await get(Uri.parse("$_baseUrl/jobs/getAllJobs"), headers: {
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
        "Connection": "Keep-Alive",
        'Authorization': 'Bearer $auth',
      });

      apiResponse.Data = AllJobsResponse.fromJson(json.decode(res.body));
    } on SocketException {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }

    return apiResponse;
  }

  Future<ApiResponse> getAllApplications(uniqueId, auth) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res = await get(
          Uri.parse("$_baseUrl/jobs/$uniqueId/applicantApplications"),
          headers: {
            'Content-Type': 'application/json',
            'Charset': 'utf-8',
            "Connection": "Keep-Alive",
            'Authorization': 'Bearer $auth',
          });
      apiResponse.Data =
          AllApplicationsResponse.fromJson(json.decode(res.body));
    } on SocketException {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }

    return apiResponse;
  }

  Future<ApiResponse> getJobDetail(jobId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res =
          await get(Uri.parse("$_baseUrl/jobs/$jobId"), headers: headers);
      apiResponse.Data = JobDetailResponse.fromJson(json.decode(res.body));
    } on SocketException {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }

    return apiResponse;
  }

  Future<ApiResponse> applyJob(String uniqueId, hrId, jobId, auth) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      Response res = await post(
        Uri.parse('$_baseUrl/jobs/$uniqueId/apply'),
        body: jsonEncode({
          'hrId': hrId,
          'applicantId': uniqueId,
          'jobId': jobId,
          'status': 'Applied',
          'currentRound': 0,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Charset': 'utf-8',
          "Connection": "Keep-Alive",
          'Authorization': 'Bearer $auth',
        },
      );

      apiResponse.Data =
          AllApplicationsResponse.fromJson(json.decode(res.body));
    } on SocketException {
      apiResponse.Data = jsonEncode({"message": "Server error. Please retry"});
    }
    return apiResponse;
  }
}
