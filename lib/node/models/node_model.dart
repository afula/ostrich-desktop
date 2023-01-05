import 'package:equatable/equatable.dart';

class NodeModel extends Equatable {
/*   jsonMap["outbounds"][0]["settings"]["address"] = serverJson["ip"];
  jsonMap["outbounds"][0]["settings"]["server_name"] = serverJson["host"];
  jsonMap["outbounds"][0]["settings"]["password"] = serverJson["passwd"];
  jsonMap["outbounds"][0]["settings"]["port"] = serverJson["port"]; */

  final String ip;
  final String host;
  final String passwd;
  final int port;
  final String country;
  final String city;

  const NodeModel(
      {required this.ip,
      required this.host,
      required this.passwd,
      required this.port,
      required this.country,
      required this.city});

  NodeModel copyWith(
      {required String? ip,
      required String? host,
      required String? passwd,
      required int? port,
      required String? country,
      required String? city}) {
    return NodeModel(
        ip: ip ?? this.ip,
        host: host ?? this.host,
        passwd: passwd ?? this.passwd,
        port: port ?? this.port,
        country: country ?? this.country,
        city: city ?? this.city);
  }

  @override
  List<Object?> get props => [ip, host, passwd, port, country, city];
}
