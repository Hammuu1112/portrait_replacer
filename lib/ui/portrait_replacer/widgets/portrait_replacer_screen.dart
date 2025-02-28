import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portrait_replacer/data/repositories/path_repository.dart';
import 'package:portrait_replacer/data/repositories/portrait_repository.dart';
import 'package:portrait_replacer/data/repositories/user_config_data_repository.dart';
import 'package:portrait_replacer/data/services/image_service.dart';
import 'package:portrait_replacer/data/services/portrait_service.dart';
import 'package:portrait_replacer/data/services/user_config_data_service.dart';
import 'package:portrait_replacer/ui/core/ui/app_bar_title.dart';
import 'package:portrait_replacer/ui/core/ui/loading_Indicator.dart';
import 'package:portrait_replacer/ui/portrait_replacer/controller/portrait_replacer_controller.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/portrait_grid_view_widget.dart';
import 'package:portrait_replacer/ui/portrait_replacer/widgets/rail_menu_widget.dart';
import 'package:portrait_replacer/utils/external_links.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class PortraitReplacerScreen extends StatefulWidget {
  const PortraitReplacerScreen({super.key});

  @override
  State<PortraitReplacerScreen> createState() => _PortraitReplacerScreenState();
}

class _PortraitReplacerScreenState extends State<PortraitReplacerScreen>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  Future<void> onWindowResized() async {
    final pref = SharedPreferencesAsync();
    final size = await windowManager.getSize();
    await pref.setDouble("window width", size.width);
    await pref.setDouble("window height", size.height);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose(); //
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ImageService()),
        Provider(
          create:
              (context) =>
                  PortraitService(path: context.read<PathRepository>().path),
        ),
        Provider(
          create:
              (context) => UserConfigDataService(
                path: context.read<PathRepository>().path,
              ),
        ),
        Provider(
          create:
              (context) => PortraitRepository(
                portraitService: context.read(),
                imageService: context.read(),
                pathService: context.read(),
                path: context.read<PathRepository>().path,
              ),
        ),
        Provider(
          create:
              (context) => UserConfigDataRepository(service: context.read()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PortraitReplacerController(
                portraitRepository: context.read(),
                pathRepository: context.read(),
                userConfigDataRepository: context.read(),
              ),
        ),
      ],
      child: Consumer<PortraitReplacerController>(
        builder: (context, controller, child) {
          if (controller.portraits == null) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: LoadingIndicator(valueStream: controller.load()),
                ),
              ),
            );
          }
          return child!;
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppBarTitle(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              /*IconButton(
                onPressed: () => openUrl(ExternalLinks.karanda),
                icon: Icon(FontAwesomeIcons.book),
              ),*/
              IconButton(
                onPressed: () => openUrl(ExternalLinks.discord),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Icon(FontAwesomeIcons.discord),
                ),
              ),
              IconButton(
                onPressed: () => openUrl(ExternalLinks.github),
                icon: Icon(FontAwesomeIcons.github),
              ),
              context.locale == Locale('ko', 'KR')
                  ? IconButton(
                    onPressed: () => openUrl(ExternalLinks.karanda),
                    icon: ImageIcon(AssetImage("assets/karanda.png")),
                  )
                  : const SizedBox(),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RailMenuWidget(),
              Expanded(child: PortraitGridViewWidget()),
            ],
          ),
          floatingActionButton: _SaveButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({super.key});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool processing = false;

  Future<void> save() async {
    setState(() {
      processing = true;
    });
    await context.read<PortraitReplacerController>().saveAllPortraits();
    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: processing ? null : save,
      tooltip: context.tr(processing ? "processing" : "save"),
      child: processing ? CircularProgressIndicator() : Icon(Icons.save),
    );
  }
}
