void main() {
  Map<String, dynamic> response = {
    "statusCode": 200,
    "data": [
      {"userId": 28, "role": "Athlete"},
      {"userId": 20, "role": "Coach / Recruiter"},
      {"userId": 30, "role": "Athlete"},
      {"userId": 48, "role": "Coach / Recruiter"}
    ]
  };

  var uniqueRole = response['data'].map((item) => item['role']).toSet().toList();

  var uniMap = {};
  uniqueRole.forEach((item) {
    uniMap[item] = response['data'].where((element) => element['role'] == item).toList();
  });
  print(uniMap);
}
