class User{
  final String name;
  final DateTime dob;
  final String gender;
  final String email;

  User({required this.name, required this.dob, required this.gender, required this.email});

   Map<String, dynamic> toJson() => {
     'name': name,
     'dob': dob,
     'gender': gender,
     'email': email
   };

   static User fromJson(Map <String, dynamic> json) => User(
     name: json['name'],
     dob: json['dob'],
     gender: json['gender'],
     email: json['email']
   );

}