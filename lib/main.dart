import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:dreamdwell/core/shared/responsive_helper.dart';
import 'package:dreamdwell/core/shared/responsive_widget_wrapper.dart';
import 'package:dreamdwell/core/utils/constant.dart';
import 'package:dreamdwell/core/theme/theme.dart';
import 'package:dreamdwell/core/routes/routes.dart';
import 'package:dreamdwell/features/properties/properties.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    ChangeNotifierProvider<PropertyProvider>(
      create: (_) => getIt<PropertyProvider>(),
      child: const DreamDwellApp(),
    ),
  );
}

class DreamDwellApp extends StatefulWidget {
  const DreamDwellApp({super.key});

  @override
  State<DreamDwellApp> createState() => _DreamDwellAppState();
}

class _DreamDwellAppState extends State<DreamDwellApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Portal(
        child: MaterialApp(
          title: 'DreamDwell',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const ScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            physics: const BouncingScrollPhysics(),
          ),
          theme: lightTheme,
          builder: (context, child) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            if (isLandscape) {
              return child ?? const SizedBox.shrink();
            }
            if (ResponsiveHelper.isDesktop(context)) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveHelper.tabletMaxWidth,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            }
            return child ?? const SizedBox.shrink();
          },
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: RouteNames.splash,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
