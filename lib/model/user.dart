
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
  String? countryFlag;
  String? city;
  double? latitude;
  double? longitude;
  String? password;
  String? userType;
  List<String>? offersAdded;
  List<String>? offersLiked;
  List<String>? comments;
  int? points;
  /*countries which posts, images,
  videos will appear on, by default
  it's only user's country
  */
  String? postsCountries;
  String? chatCountries;
  String? storyCountries;
  bool? receiveGifts;

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
      required this.country,
        required this.countryFlag,
      required this.city,
      required this.latitude,
      required this.longitude,
      required this.password,
      required this.userType,
      required this.postsCountries,
        required this.storyCountries,
        required this.chatCountries,
        this.receiveGifts,
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
    this.countryFlag = userInfo['countryFlag'] ?? '';
    this.latitude = userInfo['latitude'] ?? 0;
    this.longitude = userInfo['longitude'] ?? 0;
    //this.password = userInfo['password'];
    this.userType = userInfo['userType'];
    this.receiveGifts = userInfo['receiveGifts'] ?? false;
    this.postsCountries = userInfo['postsCountries'] ?? '';
    this.storyCountries = userInfo['storyCountries'] ?? '';
    this.chatCountries = userInfo['chatCountries'] ?? '';
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
    'countryFlag': countryFlag,
        'latitude': latitude,
        'longitude': longitude,
        //'password': password,
    'postsCountries': postsCountries,
    'chatCountries': chatCountries,
    'storyCountries': storyCountries,
        'userType': userType,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points,
    'receiveGifts': receiveGifts ?? false,
      };
}

class PersonUser extends User {
  String? gender;
  String? dateBirth;

  PersonUser({
    image,
    required userName,
    required nickName,
    required userCode,
    required email,
    required phoneNumber,
    required postsCountries,
    shortDesc,
    country,
    city,
    countryFlag,
    latitude,
    longitude,
    offersLiked,
    offersAdded,
    comments,
    points,
    receiveGifts,
    required password,
    required userType,
    id,
    required chatCountries,
    required storyCountries,
    this.dateBirth,
    this.gender,
  }) : super(
          id: id,
          postsCountries: postsCountries,
          storyCountries: storyCountries,
          chatCountries: chatCountries,
          profileImage: image,
          userName: userName,
          nickName: nickName,
          userCode: userCode,
          email: email,
          receiveGifts: receiveGifts,
          countryFlag: countryFlag,
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
    'countryFlag': countryFlag,
    'postsCountries': postsCountries,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        //'password': password,
        'userType': userType,
        'gender': gender,
        'dateBirth': dateBirth,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points,
    'chatCountries': chatCountries,
    'storyCountries': storyCountries,
    'receiveGifts': receiveGifts ?? false,
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
    required postsCountries,
    required storyCountries,
    required chatCountries,
    shortDesc,
    country,
    countryFlag,
    city,
    latitude,
    longitude,
    offersLiked,
    offersAdded,
    comments,
    receiveGifts,
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
            countryFlag: countryFlag,
            receiveGifts: receiveGifts,
            password: password,
            latitude: latitude,
            longitude: longitude,
            userType: userType,
            offersAdded: offersAdded,
            offersLiked: offersLiked,
            comments: comments,
            postsCountries: postsCountries,
            storyCountries: storyCountries,
            chatCountries: chatCountries,
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
    'receiveGifts': receiveGifts ?? false,
    'countryFlag': countryFlag,
    'postsCountries': postsCountries,
    'chatCountries': chatCountries,
    'storyCountries': storyCountries,
        'latitude': latitude,
        'longitude': longitude,
        //'password': password,
        'userType': userType,
        'offersAdded': offersAdded,
        'offersLiked': offersLiked,
        'comments': comments,
        'points': points,
        'regImages': regImages,
        'regNumber': regNumber
      };
}
