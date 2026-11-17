import '../models.dart';
import 'profile_repository.dart';

class MockProfileRepository extends ProfileRepository {
  MockProfileRepository({
    required List<Profile> profiles,
    required this.currentProfileId,
  }) : _profiles = List.of(profiles);

  final List<Profile> _profiles;

  @override
  final String currentProfileId;

  @override
  List<Profile> get profiles => List.unmodifiable(_profiles);

  @override
  Profile get currentProfile =>
      findProfile(currentProfileId) ??
      (throw StateError('Current profile does not exist.'));

  @override
  Profile? findProfile(String id) {
    for (final profile in _profiles) {
      if (profile.id == id) return profile;
    }
    return null;
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    final index = _profiles.indexWhere((saved) => saved.id == profile.id);
    if (index == -1) throw StateError('Profile ${profile.id} does not exist.');
    _profiles[index] = profile;
    notifyListeners();
  }
}
