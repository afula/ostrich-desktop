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
    // on<AddDataEvent>(_addData);
    on<UpdateNodeEvent>(_updateNode);
    // on<DeleteDataEvent>(_deleteData);
    on<UpdateMenuIndexEvent>(_updateMenuIndex);
    on<UpdateNodeIndexEvent>(_updateNodeIndex);
  }

  Future showData(ShowDataEvent event, Emitter<NodeState> emit) async {
    // final dataList = await DBHelper.selectAll(DBHelper.nodeTable);
    final dataList = event.nodeList;

    // final list = dataList
    //     .map((item) => NodeModel(
    //           ip: item['ip'],
    //           host: item['host'],
    //           passwd: item['passwd'],
    //           port: item['port'],
    //         ))
    //     .toList();

    emit(state.copyWith(
        nodeModel: dataList, menuIndex: 0, nodeIndex: 0, server: '', id: ''));
    print('SHOW DATA ${dataList}');
  }

/*   Future<void> _addData(AddDataEvent event, Emitter<NodeState> emit) async {
    Uuid uuid = const Uuid();
    final list = NodeModel(
      ip: uuid.v1(),
      host: event.host,
      passwd: event.passwd,
      port: event.port,
    );
    // DBHelper.insert(DBHelper.nodeTable, {
    //   'ip': list.ip,
    //   'host': list.host,
    //   'description': list.passwd,
    //   'port': list.port,
    // });

    final newNodes = [...state.nodeModel, list];

    emit(state.copyWith(nodeModel: newNodes, index: 1));

    print('after emit ${state.nodeModel}');
    print('_addData ${event.host}');
  } */
  Future<void> _updateNode(
      UpdateNodeEvent event, Emitter<NodeState> emit) async {
    // final List<NodeModel> nodes = event.nodeModel;

    // DBHelper.insert(DBHelper.nodeTable, {
    //   'ip': list.ip,
    //   'host': list.host,
    //   'description': list.passwd,
    //   'port': list.port,
    // });

    final List<NodeModel> newNodes = [...state.nodeModel, ...event.nodeModel];
    print("_updateIndex event nodes: $newNodes");

    emit(state.copyWith(
        nodeModel: newNodes,
        menuIndex: state.currentMenuIndex,
        nodeIndex: state.currentNodeIndex,
        server: state.server,
        id: state.id));

    print('_updateNode after emit ${state.nodeModel}');
  }

  Future<void> _updateMenuIndex(
      UpdateMenuIndexEvent event, Emitter<NodeState> emit) async {
    int menuIndex = event.index;

    // DBHelper.insert(DBHelper.nodeTable, {
    //   'ip': list.ip,
    //   'host': list.host,
    //   'description': list.passwd,
    //   'port': list.port,
    // });

    final newNodes = [...state.nodeModel];
    print("_updateIndex event index: $menuIndex");

    emit(state.copyWith(
        nodeModel: newNodes,
        menuIndex: menuIndex,
        nodeIndex: state.currentNodeIndex,
        server: state.server,
        id: state.id));

    print('_updateIndex after emit ${state.currentMenuIndex}');
  }

  Future<void> _updateNodeIndex(
      UpdateNodeIndexEvent event, Emitter<NodeState> emit) async {
    int nodeIndex = event.index;

    // DBHelper.insert(DBHelper.nodeTable, {
    //   'ip': list.ip,
    //   'host': list.host,
    //   'description': list.passwd,
    //   'port': list.port,
    // });

    final newNodes = [...state.nodeModel];
    print("_updateIndex event index: $nodeIndex");

    emit(state.copyWith(
        nodeModel: newNodes,
        menuIndex: state.currentMenuIndex,
        nodeIndex: nodeIndex,
        server: state.server,
        id: state.id));

    print('_updateIndex after emit ${state.currentNodeIndex}');
  }

/*   Future<void> _deleteData(
      DeleteDataEvent event, Emitter<NodeState> emit) async {
    final deleteObject =
        state.nodeModel.where((NodeModel node) => node.ip != event.ip).toList();
    await DBHelper.deleteById(DBHelper.nodeTable, 'ip', event.ip);
    emit(state.copyWith(nodeModel: deleteObject, index: 0));
  }

  Future<void> _updateData(
      UpdateDataEvent event, Emitter<NodeState> emit) async {
    final list = state.nodeModel.map((NodeModel nodeModel) {
      if (nodeModel.ip == event.nodeList.ip) {
        DBHelper.update(
            DBHelper.nodeTable, 'host', event.nodeList.host, event.nodeList.ip);
        DBHelper.update(DBHelper.nodeTable, 'description',
            event.nodeList.passwd, event.nodeList.ip);
        DBHelper.update(
            DBHelper.nodeTable, 'port', event.nodeList.port, event.nodeList.ip);
        return NodeModel(
          ip: event.nodeList.ip,
          host: event.nodeList.host,
          passwd: event.nodeList.passwd,
          port: event.nodeList.port,
        );
      }
      return nodeModel;
    }).toList();
    emit(state.copyWith(nodeModel: list, index: 0));
  }*/
} 

/* final list = state.nodeModel.map((NodeModel nodeModel) {
      if (nodeModel.ip == event.ip) {
        DBHelper.update(DBHelper.nodeTable, 'host', event.host, event.ip);
        DBHelper.update(
            DBHelper.nodeTable, 'description', event.passwd, event.ip);
        DBHelper.update(DBHelper.nodeTable, 'port', event.port, event.ip);
        return NodeModel(
          ip: event.ip,
          host: event.host,
          passwd: event.passwd,
          port: event.port,
        );
      }
      return nodeModel;
    }).toList(); */