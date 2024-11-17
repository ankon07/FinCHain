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
}
