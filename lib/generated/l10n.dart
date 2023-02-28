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

  /// `launch`
  String get launch {
    return Intl.message(
      'launch',
      name: 'launch',
      desc: '',
      args: [],
    );
  }

  /// `close`
  String get close {
    return Intl.message(
      'close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `exit`
  String get exit {
    return Intl.message(
      'exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `setting`
  String get setting {
    return Intl.message(
      'setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `node`
  String get node {
    return Intl.message(
      'node',
      name: 'node',
      desc: '',
      args: [],
    );
  }

  /// `server address`
  String get serverAddress {
    return Intl.message(
      'server address',
      name: 'serverAddress',
      desc: '',
      args: [],
    );
  }

  /// `user id`
  String get userId {
    return Intl.message(
      'user id',
      name: 'userId',
      desc: '',
      args: [],
    );
  }

  /// `confirm`
  String get confirm {
    return Intl.message(
      'confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Failed to start proxy`
  String get proxyInitFailure {
    return Intl.message(
      'Failed to start proxy',
      name: 'proxyInitFailure',
      desc: '',
      args: [],
    );
  }

  /// `Start proxy successfully`
  String get proxyInitSuccess {
    return Intl.message(
      'Start proxy successfully',
      name: 'proxyInitSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message(
      'Connected',
      name: 'connected',
      desc: '',
      args: [],
    );
  }

  /// `Switch`
  String get change {
    return Intl.message(
      'Switch',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Switched`
  String get changed {
    return Intl.message(
      'Switched',
      name: 'changed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to switch`
  String get changeFailure {
    return Intl.message(
      'Failed to switch',
      name: 'changeFailure',
      desc: '',
      args: [],
    );
  }

  /// `Starting`
  String get starting {
    return Intl.message(
      'Starting',
      name: 'starting',
      desc: '',
      args: [],
    );
  }

  /// `Started`
  String get started {
    return Intl.message(
      'Started',
      name: 'started',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closed {
    return Intl.message(
      'Closed',
      name: 'closed',
      desc: '',
      args: [],
    );
  }

  /// `Closed failure`
  String get closedFailure {
    return Intl.message(
      'Closed failure',
      name: 'closedFailure',
      desc: '',
      args: [],
    );
  }

  /// `The input cannt be empty`
  String get inputEmpty {
    return Intl.message(
      'The input cannt be empty',
      name: 'inputEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The input format is wrong`
  String get inputFormatWrong {
    return Intl.message(
      'The input format is wrong',
      name: 'inputFormatWrong',
      desc: '',
      args: [],
    );
  }

  /// `Fetching nodes from server`
  String get fetching {
    return Intl.message(
      'Fetching nodes from server',
      name: 'fetching',
      desc: '',
      args: [],
    );
  }

  /// `nodes are ready`
  String get fetched {
    return Intl.message(
      'nodes are ready',
      name: 'fetched',
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
      Locale.fromSubtags(languageCode: 'zh'),
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
