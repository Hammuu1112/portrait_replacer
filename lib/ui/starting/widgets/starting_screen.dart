import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:portrait_replacer/ui/core/ui/app_bar_title.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/portrait_replacer_screen.dart';
import 'package:portrait_replacer/ui/starting/controller/starting_controller.dart';
import 'package:portrait_replacer/ui/starting/widgets/background_image_widget.dart';
import 'package:portrait_replacer/ui/starting/widgets/select_language_widget.dart';
import 'package:portrait_replacer/ui/starting/widgets/select_path_widget.dart';
import 'package:portrait_replacer/ui/starting/widgets/update_card_widget.dart';
import 'package:portrait_replacer/ui/starting/widgets/version_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => StartingController(
            pathRepository: context.read(),
            versionRepository: context.read(),
          ),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            BackgroundImageWidget(),
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: AppBarTitle(),
                  actions: [VersionWidget()],
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
                body: Flex(
                  direction: Axis.horizontal,
                  children: [
                    /* Left (Select Language) */
                    Flexible(
                      flex: 1,
                      child: Card(
                        elevation: 0.0,
                        clipBehavior: Clip.antiAlias,
                        color: Colors.black.withAlpha(147),
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                          child: SelectLanguageWidget(),
                        ),
                      ),
                    ),
                    /* Right */
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /* Update Available Card */
                            UpdateCardWidget(),
                            /* Select Path */
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SelectPathWidget(),
                                ),
                                /* Start & Exit Buttons */
                                _Buttons(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({super.key});

  Future<void> start(context) async {
    final pref = SharedPreferencesAsync();
    final width = await pref.getDouble("window width") ?? 1280;
    final height = await pref.getDouble("window height") ?? 720;

    await windowManager.hide();
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setSize(Size(width, height));
    await windowManager.setResizable(true);
    await windowManager.center();
    await windowManager.show();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PortraitReplacerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 37.0,
            width: Size.infinite.width,
            margin: EdgeInsets.all(8.0),
            child: Consumer<StartingController>(
              builder: (context, controller, child) {
                return ElevatedButton(
                  onPressed: controller.available ? () => start(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: child,
                );
              },
              child: Text(context.tr("start")),
            ),
          ),
          Container(
            height: 34.0,
            width: Size.infinite.width,
            margin: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                await windowManager.hide();
                await windowManager.destroy();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(context.tr("exit")),
            ),
          ),
        ],
      ),
    );
  }
}
