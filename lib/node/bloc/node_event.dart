// import '../models/node_model.dart';
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

/* class AddDataEvent extends NodeEvent {
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
} */

class UpdateMenuIndexEvent extends NodeEvent {
  final int index;

  const UpdateMenuIndexEvent({required this.index});

  UpdateMenuIndexEvent copyWith({required int index}) {
    return UpdateMenuIndexEvent(index: index);
  }

  @override
  List<Object> get props => [index];
}

class UpdateNodeIndexEvent extends NodeEvent {
  final int index;

  const UpdateNodeIndexEvent({required this.index});

  UpdateNodeIndexEvent copyWith({required int index}) {
    return UpdateNodeIndexEvent(index: index);
  }

  @override
  List<Object> get props => [index];
}

class UpdateNodeEvent extends NodeEvent {
  final List<NodeModel> nodeModel;

  const UpdateNodeEvent({required this.nodeModel});

  UpdateNodeEvent copyWith({required List<NodeModel> nodeModel}) {
    return UpdateNodeEvent(nodeModel: nodeModel);
  }

  @override
  List<Object> get props => [nodeModel];
}
