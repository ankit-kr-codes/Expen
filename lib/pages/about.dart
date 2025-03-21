import 'package:expen/core/theme.dart';
import 'package:expen/provider/version_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  Future<void> redirectUrl(query) async {
    Uri url = Uri.parse(query);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void showLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );
    Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) => themes.wrap(
              LicensePage(
                applicationName: applicationName,
                applicationVersion: applicationVersion,
                applicationIcon: applicationIcon,
                applicationLegalese: applicationLegalese,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              onTap: () {
                redirectUrl("https://x.com/ankit_kr_codes");
              },
              title: const Text("Twitter"),
              leading: const Icon(Icons.transfer_within_a_station_rounded),
              subtitle: const Text("@ankit_kr_codes"),
            ),
            ListTile(
              onTap: () {
                redirectUrl("mailto:ankit.kr.codes@gmail.com");
              },
              title: const Text("Email"),
              leading: const Icon(Icons.email_outlined),
              subtitle: const Text("ankit.kr.codes@gmail.com"),
            ),

            //About App
            Text(
              "App",
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              onTap: () {
                showLicensePage(context: context);
              },
              title: const Text("Credits & Licenses"),
              leading: const Icon(Icons.badge_outlined),
              subtitle: const Text("Open Source Licesnses"),
            ),
            ListTile(
              onTap: () {},
              title: const Text("App Version"),
              subtitle: Text(context.watch<VersionProvider>().version),
              leading: const Icon(Icons.android),
            ),
          ],
        ),
      ),
    );
  }
}
