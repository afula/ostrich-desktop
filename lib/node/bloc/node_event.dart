part of 'node_bloc.dart';

abstract class NodeEvent extends Equatable {
  const NodeEvent();
}

class ShowDataEvent extends NodeEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
// final List<NodeModel> nodeList;
//
// const ShowDataEvent({required this.nodeList});
//
// @override
// List<Object?> get props => [nodeList];
//
// ShowDataEvent copyWith({List<NodeModel>? nodeList}) {
//   return ShowDataEvent(nodeList: nodeList ?? this.nodeList);
// }
}

class AddDataEvent extends NodeEvent {
  final String title;
  final String desc;
  final String date;

  const AddDataEvent({
    required this.title,
    required this.desc,
    required this.date,
  });

  @override
  List<Object> get props => [title, desc, date];

  AddDataEvent copyWith({
    String? title,
    String? desc,
    String? date,
  }) {
    return AddDataEvent(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      date: date ?? this.date,
    );
  }
}

class UpdateDataEvent extends NodeEvent {
  final NodeModel nodeList;

  const UpdateDataEvent(this.nodeList);

  @override
  List<Object?> get props => [nodeList];
}

class DeleteDataEvent extends NodeEvent {
  final String id;

  const DeleteDataEvent({required this.id});

  DeleteDataEvent copyWith({String? id}) {
    return DeleteDataEvent(id: id ?? this.id);
  }

  @override
  List<Object> get props => [id];
}