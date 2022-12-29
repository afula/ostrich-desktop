part of 'node_bloc.dart';

class NodeState extends Equatable {
  final List<NodeModel> nodeModel;

  const NodeState({required this.nodeModel});

  @override
  List<Object?> get props => [nodeModel];

  NodeState copyWith({required List<NodeModel> nodeModel}) {
    return NodeState(nodeModel: nodeModel ?? this.nodeModel);
  }
}
