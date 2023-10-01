class AppwriteConstants {
  static const String databaseId = '64908a1b4c4add37f45d';
  static const String projectId = '64907e0dc84cb1549cb3';
  static const String endPoint = 'http://192.168.0.102:80/v1';

  static const String usersCollection = '6497e94a6cc2710139dd';
  static const String tweetsCollection = '6498eaeabf5011623e4d';
  static const String notificationsCollection = '649d2318d78c00706c4c';

  static const String imagesBucket = '6498f69bed0e9c3bef69';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
