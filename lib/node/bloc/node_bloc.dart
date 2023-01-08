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
    on<AddNodeEvent>(_addNode);
    on<UpdateNodeEvent>(_updateNode);
    on<UpdateConnectStatusEvent>(_updateConnectedStatus);
    on<UpdateConnectedNodeEvent>(_updateConnectedNode);
    on<UpdateMenuIndexEvent>(_updateMenuIndex);
    on<UpdateNodeIndexEvent>(_updateNodeIndex);
  }

  Future _addNode(AddNodeEvent event, Emitter<NodeState> emit) async {
    // final dataList = await DBHelper.selectAll(DBHelper.nodeTable);
    final dataList = event.nodeList;
    emit(state.copyWith(nodeModel: dataList));
    print('SHOW DATA ${dataList}');
  }

  Future<void> _updateNode(
      UpdateNodeEvent event, Emitter<NodeState> emit) async {
    final List<NodeModel> newNodes = [...state.nodeModel, ...event.nodeModel];
    emit(state.copyWith(
      nodeModel: newNodes,
    ));
  }

  Future<void> _updateMenuIndex(
      UpdateMenuIndexEvent event, Emitter<NodeState> emit) async {
    int menuIndex = event.index;
    emit(state.copyWith(
      menuIndex: menuIndex,
    ));
  }

  Future<void> _updateNodeIndex(
      UpdateNodeIndexEvent event, Emitter<NodeState> emit) async {
    int nodeIndex = event.index;
    emit(state.copyWith(
      nodeIndex: nodeIndex,
    ));
  }

  Future<void> _updateConnectedStatus(
      UpdateConnectStatusEvent event, Emitter<NodeState> emit) async {
    bool status = event.status;
    emit(state.copyWith(connectStatus: status));
  }

  Future<void> _updateConnectedNode(
      UpdateConnectedNodeEvent event, Emitter<NodeState> emit) async {
    NodeModel node = event.node;
    emit(state.copyWith(connectedNode: node));
  }
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