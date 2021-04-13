import 'package:devexam/core/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  UserModel userModel;
  CurrentUserModel currentUserModel;

  const Map<String, String> userModelJson = {
    'id': 'empty',
    'email': 'test@gmail.com',
    'username': 'test',
    'photo': 'empty',
  };

  const Map<String, dynamic> currentUserModelJson = {
    'username': 'theiskaa',
    'email': 'theiskaa@test.com',
    'id': "simplfiedTestID",
    'photoUrl': 'https://picsum.photos/200/300',
    'savedQuestions': [],
  };

  setUpAll(() {
    // Initilaze [userModel].
    userModel = UserModel(
      id: 'empty',
      email: 'test@gmail.com',
      username: 'test',
      photo: 'empty',
    );

    // Initilaze [currentUserModel].
    currentUserModel = CurrentUserModel(
      username: 'theiskaa',
      email: 'theiskaa@test.com',
      id: "simplfiedTestID",
      photoUrl: 'https://picsum.photos/200/300',
      savedQuestions: [],
    );
  });

  group('UserModel', () {
    test('converts from json correctly', () {
      final userModelFromJson = UserModel.fromJson(userModelJson);

      // Need to match properties rather than instances.
      expect(userModel.id, userModelFromJson.id);
      expect(userModel.email, userModelFromJson.email);
      expect(userModel.username, userModelFromJson.username);
      expect(userModel.photo, userModelFromJson.photo);
    });

    test('converts to json correctly', () {
      final userModelToJson = userModel.toJson();

      expect(userModelJson, userModelToJson);
    });
  });

  group('CurrentUserModel', () {
    test('converts from json correctly', () {
      final modelFromJson = CurrentUserModel.fromJson(currentUserModelJson);

      // Need to match properties rather than instances.
      expect(currentUserModel.username, modelFromJson.username);
      expect(currentUserModel.email, modelFromJson.email);
      expect(currentUserModel.id, modelFromJson.id);
      expect(currentUserModel.photoUrl, modelFromJson.photoUrl);
      expect(currentUserModel.savedQuestions, modelFromJson.savedQuestions);
    });

    test('converts to json correctly', () {
      final currentUserModelToJson = currentUserModel.toJson();

      expect(currentUserModelJson, currentUserModelToJson);
    });
  });
}
