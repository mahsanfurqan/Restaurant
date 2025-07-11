class DummyUser {
  final String fullName;
  final String restaurantName;
  final String username;
  final String password;

  DummyUser({
    required this.fullName,
    required this.restaurantName,
    required this.username,
    required this.password,
  });
}

final List<DummyUser> dummyUsers = [
  DummyUser(
    fullName: 'Budi Santoso',
    restaurantName: 'Warung Budi',
    username: 'budi',
    password: 'password123',
  ),
  DummyUser(
    fullName: 'Siti Aminah',
    restaurantName: 'Resto Siti',
    username: 'siti',
    password: 'siti456',
  ),
];
