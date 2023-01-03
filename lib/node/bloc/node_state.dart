part of 'node_bloc.dart';

class NodeState extends Equatable {
  final List<NodeModel> nodeModel;
  final int currentMenuIndex;
  final int currentNodeIndex;
  final String server;
  final String id;

  const NodeState(
      {required this.nodeModel,
      this.currentMenuIndex = 0,
      this.currentNodeIndex = 0,
      this.server = '',
      this.id = ''});

  @override
  List<Object?> get props =>
      [nodeModel, currentMenuIndex, currentNodeIndex, server, id];

  NodeState copyWith({
    List<NodeModel>? nodeModel,
    int? menuIndex,
    int? nodeIndex,
    String? server,
    String? id,
  }) {
    return NodeState(
        nodeModel: nodeModel??this.nodeModel,
        currentMenuIndex: menuIndex ?? this.currentMenuIndex,
        currentNodeIndex: nodeIndex ?? this.currentNodeIndex,
        server: server ?? this.server,
        id: id ?? this.id);
  }
}
