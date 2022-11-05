class User{
  final String name;
  final String yob;
  final String gender;
  final String email;

  User({required this.name, required this.yob, required this.gender, required this.email});

   Map<String, dynamic> toJson() => {
     'name': name,
     'yob': yob,
     'gender': gender,
     'email': email
   };

   static User fromJson(Map <String, dynamic> json) => User(
     name: json['name'],
     yob: json['yob'],
     gender: json['gender'],
     email: json['email']
   );

}