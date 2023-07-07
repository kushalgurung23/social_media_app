class Recommend {
  final String userId, userName, userImage;
  bool isFollow;

  Recommend(
      {required this.userId,
      required this.userName,
      required this.userImage,
      required this.isFollow});
}
