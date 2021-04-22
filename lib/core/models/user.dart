import 'package:devexam/core/system/devexam.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserModel extends Equatable implements DevExModel {
  final String email;
  final String id;
  final String username;
  final String photo;

  const UserModel({
    @required this.email,
    @required this.id,
    @required this.username,
    @required this.photo,
  });

  static const empty =
      UserModel(email: '', id: '', username: null, photo: null);

  @override
  List<Object> get props => [email, id, username, photo];

  @override
  UserModel.fromJson(Map<String, String> json)
      : this.id = json['id'],
        this.email = json['email'],
        this.username = json['username'],
        this.photo = json['photo'];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'photo': photo,
      };
}

class CurrentUserModel implements DevExModel {
  final String username;
  final String email;
  final String photoUrl;
  final String id;
  final List<dynamic> savedQuestions;

  const CurrentUserModel({
    this.username,
    this.email,
    this.id,
    this.photoUrl,
    this.savedQuestions,
  });

  @override
  CurrentUserModel.fromJson(Map<String, dynamic> json)
      : this.username = json['username'],
        this.email = json['email'],
        this.photoUrl = json['photoUrl'],
        this.id = json['id'],
        this.savedQuestions = json['savedQuestions'];

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
