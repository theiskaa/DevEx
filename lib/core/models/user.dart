import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserModel extends Equatable {
  const UserModel({
    @required this.email,
    @required this.id,
    @required this.username,
    @required this.photo,
  })  : assert(email != null),
        assert(id != null);

  final String email;

  final String id;

  final String username;

  final String photo;

  static const empty =
      UserModel(email: '', id: '', username: null, photo: null);

  @override
  List<Object> get props => [email, id, username, photo];
}

class CurrentUserModel {
  String username;
  String email;
  String photoUrl;
  String id;
  List<dynamic> savedQuestions;

  CurrentUserModel({
    this.username,
    this.email,
    this.id,
    this.photoUrl,
    this.savedQuestions,
  });

  CurrentUserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    id = json['id'];
    savedQuestions = json['savedQuestions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['id'] = this.id;
    data['savedQuestions'] = this.savedQuestions;

    return data;
  }
}
