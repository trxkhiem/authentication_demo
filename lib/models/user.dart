class UserModel{
  final String name;
  final String yob;
  final String gender;
  final String email;

  UserModel({required this.name, required this.yob, required this.gender, required this.email});

   Map<String, dynamic> toJson() => {
     'name': name,
     'yob': yob,
     'gender': gender,
     'email': email
   };

   static UserModel fromJson(Map <String, dynamic> json) => UserModel(
     name: json['name'],
     yob: json['yob'],
     gender: json['gender'],
     email: json['email']
   );

}