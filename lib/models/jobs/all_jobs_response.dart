class AllJobsResponse {
  bool? success;
  String? message;
  List<Data>? data;

  AllJobsResponse({this.success, this.data, this.message});

  AllJobsResponse.fromJson(Map<String, dynamic> json) {
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
  bool? isActive;
  String? sId;
  String? title;
  String? description;
  String? email;
  String? tags;
  String? address;
  int? salaryRange;
  int? noOfPositions;
  String? education;
  String? experience;
  List<String>? applicants;
  String? userId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? deadline;
  int? noOfRounds;
  String? jobType;

  Data(
      {this.isActive,
      this.sId,
      this.title,
      this.description,
      this.email,
      this.tags,
      this.address,
      this.salaryRange,
      this.noOfPositions,
      this.education,
      this.experience,
      this.applicants,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.deadline,
      this.noOfRounds,
      this.jobType});

  Data.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    email = json['email'];
    tags = json['tags'];
    address = json['address'];
    salaryRange = json['salaryRange'];
    noOfPositions = json['noOfPositions'];
    education = json['education'];
    experience = json['experience'];
    applicants = json['applicants'].cast<String>();
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    deadline = json['deadline'];
    noOfRounds = json['noOfRounds'];
    jobType = json['jobType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isActive'] = isActive;
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    data['email'] = email;
    data['tags'] = tags;
    data['address'] = address;
    data['salaryRange'] = salaryRange;
    data['noOfPositions'] = noOfPositions;
    data['education'] = education;
    data['experience'] = experience;
    data['applicants'] = applicants;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['deadline'] = deadline;
    data['noOfRounds'] = noOfRounds;
    data['jobType'] = jobType;
    return data;
  }
}
