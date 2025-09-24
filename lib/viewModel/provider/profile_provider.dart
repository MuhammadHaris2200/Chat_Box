import 'package:chat_box/model/user_model.dart';
import 'package:chat_box/services/my_service/profile_service.dart';
import 'package:flutter/cupertino.dart';

class ProfileProvider extends ChangeNotifier {
  ///Profile service class initialization
  final ProfileService _profileService;

  ///Constructor
  ProfileProvider(this._profileService);

  UserModel? _user;

  UserModel? get user => _user;

  ///Load current user profile from firestore
  Future<void> loadProfile() async {
    try {
      await _profileService.getProfilePic();
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  ///hum ne user ki profile pic ko yaha update krvaya ha
  Future<void> updateProfilePic(String newProfilePic) async {
    ///is ma kaha k agr user null ha tw kuch bhi nh kro func vhi rok do
    if (user == null) return;

    ///or agr null nh ha tw user model ka object bana
    ///kr kaha k sirf profile pic ko update krdo
    _user = UserModel(
      uid: _user!.uid,
      name: _user!.name,
      email: _user!.email,
      about: _user!.about,
      phone: _user!.phone,
      profilePic: newProfilePic,
      createdAt: _user!.createdAt,
    );

    ///or yaha se update hone k bd (Profile Service)
    ///vali class ma bhi update hojaega qk ye uska link ha
    await _profileService.updateProfilePic(_user!);
    notifyListeners();
  }
}
