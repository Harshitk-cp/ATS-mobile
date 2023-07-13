class AllApplicationsResponse {
  bool? success;
  List<Data>? data;
  String? message;

  AllApplicationsResponse({this.success, this.data});

  AllApplicationsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? hrId;
  String? applicantId;
  String? jobId;
  String? status;
  int? currentRound;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.hrId,
      this.applicantId,
      this.jobId,
      this.status,
      this.currentRound,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    hrId = json['hrId'];
    applicantId = json['applicantId'];
    jobId = json['jobId'];
    status = json['status'];
    currentRound = json['currentRound'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['hrId'] = hrId;
    data['applicantId'] = applicantId;
    data['jobId'] = jobId;
    data['status'] = status;
    data['currentRound'] = currentRound;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
