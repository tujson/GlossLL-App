import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloss_ll/src/modules/configure_playback_page.dart/configre_playback_page.dart';
import 'package:gloss_ll/src/util/loading.dart';

class SelectSubtitlesPage extends StatefulWidget {
  const SelectSubtitlesPage({super.key});

  @override
  State<SelectSubtitlesPage> createState() => _SelectSubtitlesPageState();
}

class _SelectSubtitlesPageState extends State<SelectSubtitlesPage> {
  static const String _assetsSubtitlesPath = "assets/subtitles/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text("Select subtitles"),
              _buildSubtitleList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleList() {
    return FutureBuilder(
      future: AssetManifest.loadFromAssetBundle(rootBundle),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("Error while loading subtitle list: ${snapshot.error}");
            return const Text("Error while loading data.");
          } else if (snapshot.hasData) {
            List<String> srtFileNames = snapshot.data
                    ?.listAssets()
                    .where((assetPath) =>
                        assetPath.startsWith(_assetsSubtitlesPath) &&
                        assetPath.endsWith(".srt"))
                    .map((srtPath) => srtPath.split(_assetsSubtitlesPath)[1])
                    .toList() ??
                List.empty();

            srtFileNames.sort();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: srtFileNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(srtFileNames[index]),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/configure-subtitles",
                      arguments: ConfigurePlaybackPageArguments(
                        srtPath: "$_assetsSubtitlesPath${srtFileNames[index]}",
                      ),
                    );
                  },
                );
              },
            );
          }
        }

        return const Loading();
      },
    );
  }
}
