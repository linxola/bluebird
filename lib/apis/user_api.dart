import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:bluebird/constants/appwrite_constants.dart';
import 'package:bluebird/core/failure.dart';
import 'package:bluebird/core/providers.dart';
import 'package:bluebird/core/type_defs.dart';
import 'package:bluebird/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(usersAppwriteRealtimeProvider),
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
  FutureEitherVoid addToFollowing(UserModel user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollection}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid followUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'followers': user.followers,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid addToFollowing(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: user.uid,
        data: {
          'following': user.following,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
