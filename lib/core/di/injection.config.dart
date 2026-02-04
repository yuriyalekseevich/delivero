// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i7;
import 'package:delivero/core/di/register_model.dart' as _i38;
import 'package:delivero/core/di/storage_module.dart' as _i39;
import 'package:delivero/core/localization/language_cubit.dart' as _i36;
import 'package:delivero/core/localization/language_service.dart' as _i32;
import 'package:delivero/core/network/api_client.dart' as _i4;
import 'package:delivero/core/network/interceptors/debug_interceptor.dart'
    as _i8;
import 'package:delivero/core/network/interceptors/encryption_interceptor.dart'
    as _i13;
import 'package:delivero/core/network/interceptors/error_interceptor.dart'
    as _i14;
import 'package:delivero/core/network/interceptors/server_selector_interceptor.dart'
    as _i20;
import 'package:delivero/core/network/network_info.dart' as _i18;
import 'package:delivero/core/offline/action_queue.dart' as _i3;
import 'package:delivero/core/offline/offline_mode_cubit.dart' as _i19;
import 'package:delivero/core/services/app_initialization_service.dart' as _i37;
import 'package:delivero/core/services/delivery_event_bus.dart' as _i10;
import 'package:delivero/core/services/delivery_management_service.dart'
    as _i35;
import 'package:delivero/core/services/delivery_pdf_export_service.dart'
    as _i11;
import 'package:delivero/core/services/delivery_sync_service.dart' as _i26;
import 'package:delivero/core/services/location_service.dart' as _i16;
import 'package:delivero/core/storage/debug_storage.dart' as _i9;
import 'package:delivero/core/storage/hive_storage.dart' as _i15;
import 'package:delivero/features/delivery/data/datasources/delivery_local_datasource.dart'
    as _i23;
import 'package:delivero/features/delivery/data/datasources/delivery_remote_datasource.dart'
    as _i12;
import 'package:delivero/features/delivery/data/datasources/mock_delivery_api_service.dart'
    as _i17;
import 'package:delivero/features/delivery/data/models/delivery_model.dart'
    as _i6;
import 'package:delivero/features/delivery/data/repositories/delivery_repository_impl.dart'
    as _i25;
import 'package:delivero/features/delivery/domain/repositories/delivery_repository.dart'
    as _i24;
import 'package:delivero/features/delivery/domain/usecases/complete_delivery.dart'
    as _i34;
import 'package:delivero/features/delivery/domain/usecases/export_delivery_report.dart'
    as _i27;
import 'package:delivero/features/delivery/domain/usecases/get_active_deliveries.dart'
    as _i28;
import 'package:delivero/features/delivery/domain/usecases/get_completed_deliveries.dart'
    as _i29;
import 'package:delivero/features/delivery/domain/usecases/get_deliveries.dart'
    as _i30;
import 'package:delivero/features/delivery/domain/usecases/get_ready_deliveries.dart'
    as _i31;
import 'package:delivero/features/delivery/domain/usecases/start_delivery.dart'
    as _i33;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive_flutter/hive_flutter.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i21;
import 'package:uuid/uuid.dart' as _i22;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final storageModule = _$StorageModule();
    gh.factory<_i3.ActionQueue>(() => _i3.ActionQueue());
    gh.factory<_i4.ApiClient>(() => _i4.ApiClient());
    await gh.factoryAsync<_i5.Box<_i6.DeliveryModel>>(
      () => registerModule.openDeliveryBox(),
      preResolve: true,
    );
    gh.lazySingleton<_i7.Connectivity>(() => registerModule.connectivity);
    gh.factory<_i8.DebugInterceptor>(() => _i8.DebugInterceptor());
    gh.singleton<_i9.DebugStorage>(() => _i9.DebugStorage());
    gh.singleton<_i10.DeliveryEventBus>(() => _i10.DeliveryEventBus());
    gh.singleton<_i11.DeliveryPDFExportService>(
        () => _i11.DeliveryPDFExportService());
    gh.factory<_i12.DeliveryRemoteDataSource>(
        () => _i12.DeliveryRemoteDataSourceImpl(gh<_i4.ApiClient>()));
    gh.factory<_i13.EncryptionInterceptor>(() => _i13.EncryptionInterceptor());
    gh.factory<_i14.ErrorInterceptor>(() => _i14.ErrorInterceptor());
    gh.factory<_i15.HiveStorage>(() => _i15.HiveStorage());
    gh.singleton<_i16.LocationService>(() => _i16.LocationService());
    gh.singleton<_i17.MockDeliveryApiService>(
        () => _i17.MockDeliveryApiService(gh<_i16.LocationService>()));
    gh.lazySingleton<_i18.NetworkInfo>(
        () => registerModule.networkInfo(gh<_i7.Connectivity>()));
    gh.factory<_i19.OfflineModeCubit>(() => _i19.OfflineModeCubit());
    gh.factory<_i20.ServerSelectorInterceptor>(
        () => _i20.ServerSelectorInterceptor());
    await gh.singletonAsync<_i21.SharedPreferences>(
      () => storageModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i22.Uuid>(() => registerModule.uuid);
    gh.lazySingleton<_i23.DeliveryLocalDataSource>(
        () => _i23.DeliveryLocalDataSourceImpl(
              gh<_i5.Box<_i6.DeliveryModel>>(),
              gh<_i22.Uuid>(),
            ));
    gh.lazySingleton<_i24.DeliveryRepository>(() => _i25.DeliveryRepositoryImpl(
          gh<_i23.DeliveryLocalDataSource>(),
          gh<_i18.NetworkInfo>(),
          gh<_i3.ActionQueue>(),
          gh<_i19.OfflineModeCubit>(),
          gh<_i17.MockDeliveryApiService>(),
        ));
    gh.singleton<_i26.DeliverySyncService>(() => _i26.DeliverySyncService(
          gh<_i24.DeliveryRepository>(),
          gh<_i18.NetworkInfo>(),
          gh<_i17.MockDeliveryApiService>(),
        ));
    gh.factory<_i27.ExportDeliveryReport>(
        () => _i27.ExportDeliveryReport(gh<_i24.DeliveryRepository>()));
    gh.factory<_i28.GetActiveDeliveries>(
        () => _i28.GetActiveDeliveries(gh<_i24.DeliveryRepository>()));
    gh.factory<_i29.GetCompletedDeliveries>(
        () => _i29.GetCompletedDeliveries(gh<_i24.DeliveryRepository>()));
    gh.factory<_i30.GetDeliveries>(
        () => _i30.GetDeliveries(gh<_i24.DeliveryRepository>()));
    gh.factory<_i31.GetReadyDeliveries>(
        () => _i31.GetReadyDeliveries(gh<_i24.DeliveryRepository>()));
    gh.singleton<_i32.LanguageService>(
        () => _i32.LanguageService(gh<_i21.SharedPreferences>()));
    gh.factory<_i33.StartDelivery>(
        () => _i33.StartDelivery(gh<_i24.DeliveryRepository>()));
    gh.factory<_i34.CompleteDelivery>(
        () => _i34.CompleteDelivery(gh<_i24.DeliveryRepository>()));
    gh.singleton<_i35.DeliveryManagementService>(
        () => _i35.DeliveryManagementService(
              gh<_i24.DeliveryRepository>(),
              gh<_i18.NetworkInfo>(),
              gh<_i3.ActionQueue>(),
              gh<_i10.DeliveryEventBus>(),
            ));
    gh.factory<_i36.LanguageCubit>(
        () => _i36.LanguageCubit(gh<_i32.LanguageService>()));
    gh.factory<_i37.AppInitializationService>(
        () => _i37.AppInitializationService(
              gh<_i18.NetworkInfo>(),
              gh<_i26.DeliverySyncService>(),
              gh<_i35.DeliveryManagementService>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i38.RegisterModule {}

class _$StorageModule extends _i39.StorageModule {}
