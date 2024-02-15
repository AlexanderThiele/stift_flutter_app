abstract class ConfigRepository {
  Future<void> init();

  int get appStoreBuildNumber;
}
