import 'package:equatable/equatable.dart';

class NodeModel extends Equatable {
/*   jsonMap["outbounds"][0]["settings"]["address"] = serverJson["ip"];
  jsonMap["outbounds"][0]["settings"]["server_name"] = serverJson["host"];
  jsonMap["outbounds"][0]["settings"]["password"] = serverJson["passwd"];
  jsonMap["outbounds"][0]["settings"]["port"] = serverJson["port"]; */

  final String ip;
  final String host;
  final String passwd;
  final String port;

  const NodeModel({
    required this.ip,
    required this.host,
    required this.passwd,
    required this.port,
  });

  NodeModel copyWith({
    String? ip,
    String? host,
    String? passwd,
    String? port,
  }) {
    return NodeModel(
      ip: ip ?? this.ip,
      host: host ?? this.host,
      passwd: passwd ?? this.passwd,
      port: port ?? this.port,
    );
  }

  @override
  List<Object?> get props => [ip, host, passwd, port];
}
