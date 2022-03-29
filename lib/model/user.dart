
class User {
  String? id;
  String? profileImage;
  String? coverImage;
  String? userName;
  String? nickName;
  String? userCode;
  String? email;
  String? phoneNumber;
  String? shortDesc;
  String? country;
  String? city;
  double? latitude;
  double? longitude;
  String? password;
  String? userType;
  List<String>? offersAdded;
  List<String>? offersLiked;
  List<String>? comments;
  int? points;

  User(
      {this.profileImage,
        this.coverImage,
      this.id,
      required this.userName,
      required this.nickName,
      required this.userCode,
      required this.email,
      required this.phoneNumber,
      this.shortDesc,
      this.country,
      this.city,
      this.latitude,
      this.longitude,
      required this.password,
      required this.userType,
      this.offersAdded,
      this.offersLiked,
      this.comments,
      this.points});

  User.fromMap(Map<String, dynamic> userInfo, String uId) {
    this.profileImage = userInfo['profileImage'] ?? '';
    this.coverImage = userInfo['coverImage'] ?? '';
    this.id = uId;
    this.userName = userInfo['userName'];
    this.nickName = userInfo['nickName'];
    this.userCode = userInfo['userCode'];
    this.email = userInfo['email'];
    this.phoneNumber = userInfo['phoneNumber'];
    this.shortDesc = userInfo['shortDesc'] ?? '';
    this.country = userInfo['country'] ?? '';
    this.city = userInfo['city'] ?? '';
    this.latitude = userInfo['latitude'] ?? 0;
    this.longitude = userInfo['longitude'] ?? 0;
    this.password = userInfo['password'];
    this.userType = userInfo['userType'];
    this.offersAdded = ((userInfo['offersAdded'] ?? []) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    this.offersLiked = ((userInfo['offersLiked'] ?? []) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    this.comments = ((userInfo['comments'] ?? []) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    this.points = userInfo['points'] ?? 0;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'profileImage': profileImage,
    'coverImage': coverImage,
        'userName': userName,
        'nickName': nickName,
        'userCode': userCode,
        'email': email,
        'phoneNumber': phoneNumber,
        'shortDesc': shortDesc,
        'country': country,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'password': password,
        'userType': userType,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points
      };
}

class PersonUser extends User {
  String? gender;
  String? dateBirth;
  List<String>? chatCountries;
  List<String>? storyCountries;

  PersonUser({
    image,
    required userName,
    required nickName,
    required userCode,
    required email,
    required phoneNumber,
    shortDesc,
    country,
    city,
    latitude,
    longitude,
    offersLiked,
    offersAdded,
    comments,
    points,
    required password,
    required userType,
    id,
    this.chatCountries,
    this.storyCountries,
    this.dateBirth,
    this.gender,
  }) : super(
          id: id,
          profileImage: image,
          userName: userName,
          nickName: nickName,
          userCode: userCode,
          email: email,
          phoneNumber: phoneNumber,
          shortDesc: shortDesc,
          country: country,
          city: city,
          password: password,
          latitude: latitude,
          longitude: longitude,
          userType: userType,
          offersAdded: offersAdded,
          offersLiked: offersLiked,
          comments: comments,
          points: points,
        );

  PersonUser.fromMap(Map<String, dynamic> userInfo, String uId)
      : super.fromMap(userInfo, uId) {
    this.gender = userInfo['gender'] ?? '';
    this.dateBirth = userInfo['dateBirth'] ?? '';
    this.storyCountries = ((userInfo['storyCountries'] ?? []) as List<dynamic>).map((e) => e.toString()).toList();
    this.chatCountries = ((userInfo['chatCountries'] ?? []) as List<dynamic>).map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'profileImage': profileImage,
    'coverImage': coverImage,
        'userName': userName,
        'nickName': nickName,
        'userCode': userCode,
        'email': email,
        'phoneNumber': phoneNumber,
        'shortDesc': shortDesc,
        'country': country,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'password': password,
        'userType': userType,
        'gender': gender,
        'dateBirth': dateBirth,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points,
    'chatCountries': chatCountries,
    'storyCountries': storyCountries,
      };
}

class CompanyUser extends User {
  List<String>? regImages;
  String? regNumber;

  CompanyUser({
    image,
    required userName,
    required nickName,
    required userCode,
    required email,
    required phoneNumber,
    shortDesc,
    country,
    city,
    latitude,
    longitude,
    offersLiked,
    offersAdded,
    comments,
    points,
    required password,
    required userType,
    id,
    this.regImages,
    required this.regNumber,
  }) : super(
            id: id,
            profileImage: image,
            userName: userName,
            nickName: nickName,
            userCode: userCode,
            email: email,
            phoneNumber: phoneNumber,
            shortDesc: shortDesc,
            country: country,
            city: city,
            password: password,
            latitude: latitude,
            longitude: longitude,
            userType: userType,
            offersAdded: offersAdded,
            offersLiked: offersLiked,
            comments: comments,
            points: points);

  CompanyUser.fromMap(Map<String, dynamic> userInfo, String uId)
      : super.fromMap(userInfo, uId) {
    this.regImages = ((userInfo['regImages'] ?? []) as List<dynamic>).map((e) => e.toString()).toList();
    this.regNumber = userInfo['regNumber'] ?? '';
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'profileImage': profileImage,
    'coverImage': coverImage,
        'userName': userName,
        'nickName': nickName,
        'userCode': userCode,
        'email': email,
        'phoneNumber': phoneNumber,
        'shortDesc': shortDesc,
        'country': country,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'password': password,
        'userType': userType,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points,
        'regImages': regImages,
        'regNumber': regNumber
      };
}
