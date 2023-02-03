import 'package:pachub/Utils/images.dart';

class User {
  final int? id;
  final String name;
  final String image;
  final bool isOnline;

  User({this.id, required this.name, required this.image, required this.isOnline});
}

//You current user
final User currentUser = User(
  id: 0,
  name: 'Rohit Dana',
  image: userImages1,
  isOnline: true,
);

// USERs
final User janeCooper = User(
  id: 1,
  name: 'Jane Cooper',
  image: userImages2,
  isOnline: true,
);

final User ralphEdwards = User(
  id: 2,
  name: 'Ralph Edwards',
  image: userImages3,
  isOnline: false,
);
final User brooklynSimmons = User(
  id: 3,
  name: 'Brooklyn Simmons',
  image: userImages4,
  isOnline: false,
);
final User albertFlores = User(
  id: 4,
  name: 'Albert Flores',
  image: userImages5,
  isOnline: true,
);
final User cameronWilliamson = User(
  id: 5,
  name: 'Cameron Williamson',
  image: userImages6,
  isOnline: false,
);
final User kristinWatson = User(
  id: 5,
  name: 'Kristin Watson',
  image: userImages4,
  isOnline: true,
);
final User jennyWilson = User(
  id: 6,
  name: 'Jenny Wilson',
  image: userImages3,
  isOnline: false,
);


