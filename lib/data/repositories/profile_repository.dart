import 'package:flutter/foundation.dart';

import '../models.dart';

abstract class ProfileRepository extends ChangeNotifier {
  List<Profile> get profiles;
  String get currentProfileId;
  Profile get currentProfile;

  Profile? findProfile(String id);
  Future<void> saveProfile(Profile profile);
}
