import 'package:delivero/generated/l10n.dart';
import 'package:delivero/preparation_testing/test_listview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/offline/offline_mode_cubit.dart';
import 'core/localization/language_cubit.dart';
import 'core/services/app_initialization_service.dart';
import 'features/delivery/presentation/cubit/delivery_cubit.dart';
import 'features/delivery/presentation/cubit/delivery_list_cubit.dart';
import 'features/delivery/presentation/cubit/offline_sync_cubit.dart';
import 'features/delivery/presentation/pages/delivery_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await configureDependencies();

  // final appInitService = getIt<AppInitializationService>();
  // await appInitService.initializeApp();
  debugPrintRebuildDirtyWidgets = true;
  runApp(MaterialApp(title: 'Delivero', home: ExampleWidget()));
}

class DeliveroApp extends StatelessWidget {
  const DeliveroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => getIt<LanguageCubit>(),
        ),
        BlocProvider<OfflineModeCubit>(
          create: (context) => OfflineModeCubit(),
        ),
        BlocProvider<OfflineSyncCubit>(
          create: (context) => OfflineSyncCubit(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DeliveryCubit>(
            create: (context) => DeliveryCubit(),
          ),
          BlocProvider<DeliveryListCubit>(
            create: (context) => DeliveryListCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp(
                    title: 'Delivero',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    locale: locale,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    //home: const DeliveryListPage(),
                    home: ExampleWidget());
              },
            );
          },
        ),
      ),
    );
  }
}
