// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.59.0.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member

import 'dart:convert';
import 'dart:async';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

import 'package:meta/meta.dart';
import 'package:meta/meta.dart';
import 'dart:ffi' as ffi;

abstract class Native {
  Future<int> leafRun(
      {required String configPath,
      required String wintunPath,
      required String tun2SocksPath,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kLeafRunConstMeta;

  Future<bool> isRunning({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIsRunningConstMeta;

  Future<bool> leafShutdown({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kLeafShutdownConstMeta;

  Future<String> ping({required String host, required int port, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kPingConstMeta;

  Future<void> requireAdministrator({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kRequireAdministratorConstMeta;

  Future<bool> isElevated({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIsElevatedConstMeta;

  Future<bool> isAppElevated({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIsAppElevatedConstMeta;
}

class NativeImpl implements Native {
  final NativePlatform _platform;
  factory NativeImpl(ExternalLibrary dylib) =>
      NativeImpl.raw(NativePlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory NativeImpl.wasm(FutureOr<WasmModule> module) =>
      NativeImpl(module as ExternalLibrary);
  NativeImpl.raw(this._platform);
  Future<int> leafRun(
      {required String configPath,
      required String wintunPath,
      required String tun2SocksPath,
      dynamic hint}) {
    var arg0 = _platform.api2wire_String(configPath);
    var arg1 = _platform.api2wire_String(wintunPath);
    var arg2 = _platform.api2wire_String(tun2SocksPath);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_leaf_run(port_, arg0, arg1, arg2),
      parseSuccessData: _wire2api_i32,
      constMeta: kLeafRunConstMeta,
      argValues: [configPath, wintunPath, tun2SocksPath],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kLeafRunConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "leaf_run",
        argNames: ["configPath", "wintunPath", "tun2SocksPath"],
      );

  Future<bool> isRunning({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_is_running(port_),
      parseSuccessData: _wire2api_bool,
      constMeta: kIsRunningConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kIsRunningConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "is_running",
        argNames: [],
      );

  Future<bool> leafShutdown({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_leaf_shutdown(port_),
      parseSuccessData: _wire2api_bool,
      constMeta: kLeafShutdownConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kLeafShutdownConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "leaf_shutdown",
        argNames: [],
      );

  Future<String> ping({required String host, required int port, dynamic hint}) {
    var arg0 = _platform.api2wire_String(host);
    var arg1 = _platform.api2wire_i64(port);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_ping(port_, arg0, arg1),
      parseSuccessData: _wire2api_String,
      constMeta: kPingConstMeta,
      argValues: [host, port],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kPingConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "ping",
        argNames: ["host", "port"],
      );

  Future<void> requireAdministrator({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_require_administrator(port_),
      parseSuccessData: _wire2api_unit,
      constMeta: kRequireAdministratorConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kRequireAdministratorConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "require_administrator",
        argNames: [],
      );

  Future<bool> isElevated({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_is_elevated(port_),
      parseSuccessData: _wire2api_bool,
      constMeta: kIsElevatedConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kIsElevatedConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "is_elevated",
        argNames: [],
      );

  Future<bool> isAppElevated({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_is_app_elevated(port_),
      parseSuccessData: _wire2api_bool,
      constMeta: kIsAppElevatedConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kIsAppElevatedConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "is_app_elevated",
        argNames: [],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  int _wire2api_i32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }
}

// Section: api2wire

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class NativePlatform extends FlutterRustBridgeBase<NativeWire> {
  NativePlatform(ffi.DynamicLibrary dylib) : super(NativeWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  int api2wire_i64(int raw) {
    return raw;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.

/// generated by flutter_rust_bridge
class NativeWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_leaf_run(
    int port_,
    ffi.Pointer<wire_uint_8_list> config_path,
    ffi.Pointer<wire_uint_8_list> wintun_path,
    ffi.Pointer<wire_uint_8_list> tun2socks_path,
  ) {
    return _wire_leaf_run(
      port_,
      config_path,
      wintun_path,
      tun2socks_path,
    );
  }

  late final _wire_leaf_runPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_leaf_run');
  late final _wire_leaf_run = _wire_leaf_runPtr.asFunction<
      void Function(int, ffi.Pointer<wire_uint_8_list>,
          ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_is_running(
    int port_,
  ) {
    return _wire_is_running(
      port_,
    );
  }

  late final _wire_is_runningPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_is_running');
  late final _wire_is_running =
      _wire_is_runningPtr.asFunction<void Function(int)>();

  void wire_leaf_shutdown(
    int port_,
  ) {
    return _wire_leaf_shutdown(
      port_,
    );
  }

  late final _wire_leaf_shutdownPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_leaf_shutdown');
  late final _wire_leaf_shutdown =
      _wire_leaf_shutdownPtr.asFunction<void Function(int)>();

  void wire_ping(
    int port_,
    ffi.Pointer<wire_uint_8_list> host,
    int port,
  ) {
    return _wire_ping(
      port_,
      host,
      port,
    );
  }

  late final _wire_pingPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Int64)>>('wire_ping');
  late final _wire_ping = _wire_pingPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_require_administrator(
    int port_,
  ) {
    return _wire_require_administrator(
      port_,
    );
  }

  late final _wire_require_administratorPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_require_administrator');
  late final _wire_require_administrator =
      _wire_require_administratorPtr.asFunction<void Function(int)>();

  void wire_is_elevated(
    int port_,
  ) {
    return _wire_is_elevated(
      port_,
    );
  }

  late final _wire_is_elevatedPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_is_elevated');
  late final _wire_is_elevated =
      _wire_is_elevatedPtr.asFunction<void Function(int)>();

  void wire_is_app_elevated(
    int port_,
  ) {
    return _wire_is_app_elevated(
      port_,
    );
  }

  late final _wire_is_app_elevatedPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_is_app_elevated');
  late final _wire_is_app_elevated =
      _wire_is_app_elevatedPtr.asFunction<void Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

class _Dart_Handle extends ffi.Opaque {}

class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<ffi.Bool Function(DartPort, ffi.Pointer<ffi.Void>)>>;
typedef DartPort = ffi.Int64;

const int ERR_OK = 0;

const int ERR_CONFIG_PATH = 1;

const int ERR_CONFIG = 2;

const int ERR_IO = 3;

const int ERR_WATCHER = 4;

const int ERR_ASYNC_CHANNEL_SEND = 5;

const int ERR_SYNC_CHANNEL_RECV = 6;

const int ERR_RUNTIME_MANAGER = 7;

const int ERR_NO_CONFIG_FILE = 8;
