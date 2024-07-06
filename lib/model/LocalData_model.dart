class User {
  final int? id;
  final String name;
  final String email;
  final String profilePicture;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.profilePicture});

  // Convert a User into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  // Extract a User object from a Map.
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
    );
  }
}
