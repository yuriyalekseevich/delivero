import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/offline/offline_mode_cubit.dart';
import '../../../../core/localization/language_cubit.dart';
import '../cubit/delivery_cubit.dart';
import '../cubit/delivery_list_cubit.dart';
import '../cubit/offline_sync_cubit.dart';
import '../widgets/paginated_delivery_list.dart';
import '../widgets/offline_indicator.dart';
import 'debug_page.dart';
import 'delivery_maps_page.dart';

class DeliveryListPage extends StatefulWidget {
  const DeliveryListPage({super.key});

  @override
  State<DeliveryListPage> createState() => _DeliveryListPageState();
}

class _DeliveryListPageState extends State<DeliveryListPage> with TickerProviderStateMixin {
  int _debugTapCount = 0;
  String _currentTab = 'ready';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = ['ready', 'active', 'completed'][_tabController.index];
      });
    });
    context.read<DeliveryCubit>().loadDeliveries();
    context.read<DeliveryCubit>().checkConnectivityAndShowMessage();
    context.read<OfflineSyncCubit>().checkConnectivity();
    context.read<OfflineSyncCubit>().listenToConnectivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDebugTap() {
    setState(() {
      _debugTapCount++;
    });

    if (_debugTapCount >= 10) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const DebugPage()),
      );
      setState(() {
        _debugTapCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        centerTitle: false,
        actions: [
          BlocBuilder<OfflineModeCubit, bool>(
            builder: (context, isOffline) {
              return IconButton(
                icon: Icon(isOffline ? Icons.cloud_off : Icons.cloud),
                color: isOffline ? Colors.orange : Colors.green,
                onPressed: () => _toggleOfflineMode(context),
                tooltip: isOffline ? 'Switch to Online' : 'Switch to Offline',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _toggleTheme(context),
          ),
          BlocBuilder<OfflineSyncCubit, OfflineSyncState>(
            builder: (context, state) {
              return OfflineIndicator(state: state);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _onDebugTap,
        child: BlocListener<DeliveryCubit, DeliveryState>(
          listener: (context, state) {
            if (state is DeliveryOfflineNotification) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: S.of(context).readyToTake,
                    icon: const Icon(Icons.assignment),
                  ),
                  Tab(
                    text: S.of(context).active,
                    icon: const Icon(Icons.local_shipping),
                  ),
                  Tab(
                    text: S.of(context).completed,
                    icon: const Icon(Icons.check_circle),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    PaginatedDeliveryList(tab: 'ready'),
                    PaginatedDeliveryList(tab: 'active'),
                    PaginatedDeliveryList(tab: 'completed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDeliveryMap(context),
        tooltip: 'View Delivery Map',
        child: const Icon(Icons.map),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, currentLocale) {
            return AlertDialog(
              title: Text(S.of(context).appTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(S.of(context).english),
                    leading: const Icon(Icons.language),
                    trailing: currentLocale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<LanguageCubit>().changeLanguage('en');
                    },
                  ),
                  ListTile(
                    title: Text(S.of(context).spanish),
                    leading: const Icon(Icons.language),
                    trailing: currentLocale.languageCode == 'es' ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<LanguageCubit>().changeLanguage('es');
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleTheme(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  void _toggleOfflineMode(BuildContext context) {
    context.read<OfflineModeCubit>().toggleOfflineMode();
  }

  void _showDeliveryMap(BuildContext context) {
    final deliveryListCubit = context.read<DeliveryListCubit>();
    List<Delivery> deliveriesToShow = <Delivery>[];

    if (deliveryListCubit.state is DeliveryListLoaded) {
      final loadedState = deliveryListCubit.state as DeliveryListLoaded;
      deliveriesToShow = loadedState.deliveries;
    }

    String mapTitle;
    switch (_currentTab) {
      case 'ready':
        mapTitle = S.of(context).readyToTake;
        break;
      case 'active':
        mapTitle = S.of(context).active;
        break;
      case 'completed':
        mapTitle = S.of(context).completed;
        break;
      default:
        mapTitle = S.of(context).deliveries;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DeliveryMapsPage(
          deliveries: deliveriesToShow,
          title: mapTitle,
        ),
      ),
    );
  }
}
