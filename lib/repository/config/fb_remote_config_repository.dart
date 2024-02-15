import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pencalendar/repository/config/config_repository.dart';

class FBRemoteConfigRepository extends ConfigRepository {
  static const String _appStoreBuildNumber = "app_store_build_number";

  @override
  Future<void> init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 6),
    ));
    await remoteConfig.setDefaults(const {
      _appStoreBuildNumber: 1,
    });
    await remoteConfig.fetchAndActivate();
  }

  @override
  int get appStoreBuildNumber => FirebaseRemoteConfig.instance.getInt(_appStoreBuildNumber);
}
