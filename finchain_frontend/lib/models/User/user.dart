class User {
  String name;
  String? email;
  String contact;
  String? imageUrl;

  User({
    required this.name,
    this.email,
    required this.contact,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json, String contact) {
    String name = '';
    if (json['first_name'] != null && json['last_name'] != null) {
      name = "${json['first_name']} ${json['last_name']}".trim();
    } else {
      name = json['name'] ?? '';
    }

    return User(
      name: name,
      email: json['email'],
      contact: contact,
      imageUrl: json['profile_picture'] ?? 'assets/images/user.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'image_url': imageUrl,
    };
  }
}
