// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `delivero_app`
  String get applicationTitle {
    return Intl.message(
      'delivero_app',
      name: 'applicationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delivero`
  String get appTitle {
    return Intl.message(
      'Delivero',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Deliveries`
  String get deliveries {
    return Intl.message(
      'Deliveries',
      name: 'deliveries',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Start Delivery`
  String get startDelivery {
    return Intl.message(
      'Start Delivery',
      name: 'startDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Complete Delivery`
  String get completeDelivery {
    return Intl.message(
      'Complete Delivery',
      name: 'completeDelivery',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newDelivery {
    return Intl.message(
      'New',
      name: 'newDelivery',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message(
      'In Progress',
      name: 'inProgress',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Ready to Take`
  String get readyToTake {
    return Intl.message(
      'Ready to Take',
      name: 'readyToTake',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message(
      'Offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Sync Pending`
  String get syncPending {
    return Intl.message(
      'Sync Pending',
      name: 'syncPending',
      desc: '',
      args: [],
    );
  }

  /// `Debug Screen`
  String get debugScreen {
    return Intl.message(
      'Debug Screen',
      name: 'debugScreen',
      desc: '',
      args: [],
    );
  }

  /// `API Logs`
  String get apiLogs {
    return Intl.message(
      'API Logs',
      name: 'apiLogs',
      desc: '',
      args: [],
    );
  }

  /// `Clear Logs`
  String get clearLogs {
    return Intl.message(
      'Clear Logs',
      name: 'clearLogs',
      desc: '',
      args: [],
    );
  }

  /// `Send Notification`
  String get sendNotification {
    return Intl.message(
      'Send Notification',
      name: 'sendNotification',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message(
      'Light Theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Online`
  String get switchToOnline {
    return Intl.message(
      'Switch to Online',
      name: 'switchToOnline',
      desc: '',
      args: [],
    );
  }

  /// `Switch to Offline`
  String get switchToOffline {
    return Intl.message(
      'Switch to Offline',
      name: 'switchToOffline',
      desc: '',
      args: [],
    );
  }

  /// `PDF Export Successful!`
  String get pdfExportSuccessful {
    return Intl.message(
      'PDF Export Successful!',
      name: 'pdfExportSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Your delivery report has been generated and is ready to share.`
  String get pdfExportDescription {
    return Intl.message(
      'Your delivery report has been generated and is ready to share.',
      name: 'pdfExportDescription',
      desc: '',
      args: [],
    );
  }

  /// `Share Delivery Report`
  String get shareDeliveryReport {
    return Intl.message(
      'Share Delivery Report',
      name: 'shareDeliveryReport',
      desc: '',
      args: [],
    );
  }

  /// `Choose how you'd like to share your delivery report:`
  String get chooseShareMethod {
    return Intl.message(
      'Choose how you\'d like to share your delivery report:',
      name: 'chooseShareMethod',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsapp {
    return Intl.message(
      'WhatsApp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Telegram`
  String get telegram {
    return Intl.message(
      'Telegram',
      name: 'telegram',
      desc: '',
      args: [],
    );
  }

  /// `Cloud`
  String get cloud {
    return Intl.message(
      'Cloud',
      name: 'cloud',
      desc: '',
      args: [],
    );
  }

  /// `Copy Link`
  String get copyLink {
    return Intl.message(
      'Copy Link',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Link copied to clipboard!`
  String get linkCopied {
    return Intl.message(
      'Link copied to clipboard!',
      name: 'linkCopied',
      desc: '',
      args: [],
    );
  }

  /// `Email sharing - TODO: Implement`
  String get emailSharing {
    return Intl.message(
      'Email sharing - TODO: Implement',
      name: 'emailSharing',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp sharing - TODO: Implement`
  String get whatsappSharing {
    return Intl.message(
      'WhatsApp sharing - TODO: Implement',
      name: 'whatsappSharing',
      desc: '',
      args: [],
    );
  }

  /// `Telegram sharing - TODO: Implement`
  String get telegramSharing {
    return Intl.message(
      'Telegram sharing - TODO: Implement',
      name: 'telegramSharing',
      desc: '',
      args: [],
    );
  }

  /// `Cloud sharing - TODO: Implement`
  String get cloudSharing {
    return Intl.message(
      'Cloud sharing - TODO: Implement',
      name: 'cloudSharing',
      desc: '',
      args: [],
    );
  }

  /// `Theme toggle - TODO: Implement`
  String get themeToggle {
    return Intl.message(
      'Theme toggle - TODO: Implement',
      name: 'themeToggle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to export PDF: {error}`
  String failedToExportPDF(Object error) {
    return Intl.message(
      'Failed to export PDF: $error',
      name: 'failedToExportPDF',
      desc: '',
      args: [error],
    );
  }

  /// `PDF report exported successfully!`
  String get pdfReportExportedSuccessfully {
    return Intl.message(
      'PDF report exported successfully!',
      name: 'pdfReportExportedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Español`
  String get spanish {
    return Intl.message(
      'Español',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Map`
  String get deliveryMap {
    return Intl.message(
      'Delivery Map',
      name: 'deliveryMap',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Location`
  String get refreshLocation {
    return Intl.message(
      'Refresh Location',
      name: 'refreshLocation',
      desc: '',
      args: [],
    );
  }

  /// `Map Information`
  String get mapInfo {
    return Intl.message(
      'Map Information',
      name: 'mapInfo',
      desc: '',
      args: [],
    );
  }

  /// `View all delivery locations on an interactive map`
  String get mapInfoDescription {
    return Intl.message(
      'View all delivery locations on an interactive map',
      name: 'mapInfoDescription',
      desc: '',
      args: [],
    );
  }

  /// `Different colors represent delivery status`
  String get mapInfoLegend {
    return Intl.message(
      'Different colors represent delivery status',
      name: 'mapInfoLegend',
      desc: '',
      args: [],
    );
  }

  /// `Use controls to zoom, filter, and navigate`
  String get mapInfoControls {
    return Intl.message(
      'Use controls to zoom, filter, and navigate',
      name: 'mapInfoControls',
      desc: '',
      args: [],
    );
  }

  /// `Show All Deliveries`
  String get showAllDeliveries {
    return Intl.message(
      'Show All Deliveries',
      name: 'showAllDeliveries',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message(
      'Directions',
      name: 'directions',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Status`
  String get filterByStatus {
    return Intl.message(
      'Filter by Status',
      name: 'filterByStatus',
      desc: '',
      args: [],
    );
  }

  /// `Status Legend`
  String get statusLegend {
    return Intl.message(
      'Status Legend',
      name: 'statusLegend',
      desc: '',
      args: [],
    );
  }

  /// `Fit All Markers`
  String get fitAllMarkers {
    return Intl.message(
      'Fit All Markers',
      name: 'fitAllMarkers',
      desc: '',
      args: [],
    );
  }

  /// `Center on User Location`
  String get centerOnUserLocation {
    return Intl.message(
      'Center on User Location',
      name: 'centerOnUserLocation',
      desc: '',
      args: [],
    );
  }

  /// `Change Map Type`
  String get changeMapType {
    return Intl.message(
      'Change Map Type',
      name: 'changeMapType',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
