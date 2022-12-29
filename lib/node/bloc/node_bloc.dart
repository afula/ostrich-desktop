import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/node_model.dart';
import 'package:uuid/uuid.dart';

import '../database/db.dart';

part 'node_event.dart';
part 'node_state.dart';

class NodeBloc extends Bloc<NodeEvent, NodeState> {
  NodeBloc() : super(const NodeState(nodeModel: [])) {
    on<ShowDataEvent>(showData);
    on<AddDataEvent>(_addData);
    on<UpdateDataEvent>(_updateData);
    on<DeleteDataEvent>(_deleteData);
  }

  Future showData(ShowDataEvent event, Emitter<NodeState> emit) async {
    final dataList = await DBHelper.selectAll(DBHelper.nodeTable);

    final list = dataList
        .map((item) => NodeModel(
              id: item['id'],
              title: item['title'],
              desc: item['description'],
              date: item['date'],
            ))
        .toList();

    emit(state.copyWith(nodeModel: list));
    print('SHOW DATA ${list.length}');
  }

  Future<void> _addData(AddDataEvent event, Emitter<NodeState> emit) async {
    Uuid uuid = const Uuid();
    final list = NodeModel(
      id: uuid.v1(),
      title: event.title,
      desc: event.desc,
      date: event.date,
    );
    // DBHelper.insert(DBHelper.nodeTable, {
    //   'id': list.id,
    //   'title': list.title,
    //   'description': list.desc,
    //   'date': list.date,
    // });

    final newNodes = [...state.nodeModel, list];

    emit(state.copyWith(nodeModel: newNodes));

    print('after emit ${state.nodeModel}');
    print('_addData ${event.title}');
  }

  Future<void> _deleteData(
      DeleteDataEvent event, Emitter<NodeState> emit) async {
    final deleteObject =
        state.nodeModel.where((NodeModel node) => node.id != event.id).toList();
    await DBHelper.deleteById(DBHelper.nodeTable, 'id', event.id);
    emit(state.copyWith(nodeModel: deleteObject));
  }

  Future<void> _updateData(
      UpdateDataEvent event, Emitter<NodeState> emit) async {
    final list = state.nodeModel.map((NodeModel nodeModel) {
      if (nodeModel.id == event.nodeList.id) {
        DBHelper.update(DBHelper.nodeTable, 'title', event.nodeList.title,
            event.nodeList.id);
        DBHelper.update(DBHelper.nodeTable, 'description', event.nodeList.desc,
            event.nodeList.id);
        DBHelper.update(
            DBHelper.nodeTable, 'date', event.nodeList.date, event.nodeList.id);
        return NodeModel(
          id: event.nodeList.id,
          title: event.nodeList.title,
          desc: event.nodeList.desc,
          date: event.nodeList.date,
        );
      }
      return nodeModel;
    }).toList();
    emit(state.copyWith(nodeModel: list));
  }
}
//final list = state.nodeModel.map((NodeModel nodeModel) {
//       if (nodeModel.id == event.id) {
//         DBHelper.update(DBHelper.nodeTable, 'title', event.title, event.id);
//         DBHelper.update(
//             DBHelper.nodeTable, 'description', event.desc, event.id);
//         DBHelper.update(DBHelper.nodeTable, 'date', event.date, event.id);
//         return NodeModel(
//           id: event.id,
//           title: event.title,
//           desc: event.desc,
//           date: event.date,
//         );
//       }
//       return nodeModel;
//     }).toList();