import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:localizations/localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pencalendar/repository/repository_provider.dart';

class StartupDialogWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const StartupDialogWrapper({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartupDialogWrapperState();
}

class _StartupDialogWrapperState extends ConsumerState<StartupDialogWrapper> {
  @override
  void initState() {
    _handleUpdateDialog();
    super.initState();
  }

  void _handleUpdateDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int? buildNumber = int.tryParse(packageInfo.buildNumber);

    if (buildNumber != null && ref.read(configRepositoryProvider).appStoreBuildNumber > buildNumber) {
      _showUpdateDialog();
    }
  }

  _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(context.l10n.updateDialogTitle),
          content: Text(context.l10n.updateDialogText),
          actions: [
            TextButton(
              child: Text(context.l10n.updateDialogButtonUpdate),
              onPressed: () {
                InAppReview.instance.openStoreListing(appStoreId: "1661094074");
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(context.l10n.updateDialogButtonLater),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
