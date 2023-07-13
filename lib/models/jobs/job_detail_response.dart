class JobDetailResponse {
  bool? success;
  Data? data;

  JobDetailResponse({this.success, this.data});

  JobDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  int? noOfRounds;
  String? jobType;
  List<String>? applicants;
  String? userId;
  bool? isActive;
  String? deadline;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.title,
      this.description,
      this.email,
      this.tags,
      this.address,
      this.salaryRange,
      this.noOfPositions,
      this.education,
      this.experience,
      this.noOfRounds,
      this.jobType,
      this.applicants,
      this.userId,
      this.isActive,
      this.deadline,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
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
    noOfRounds = json['noOfRounds'];
    jobType = json['jobType'];
    applicants = json['applicants'].cast<String>();
    userId = json['userId'];
    isActive = json['isActive'];
    deadline = json['deadline'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['noOfRounds'] = noOfRounds;
    data['jobType'] = jobType;
    data['applicants'] = applicants;
    data['userId'] = userId;
    data['isActive'] = isActive;
    data['deadline'] = deadline;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
