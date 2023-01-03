import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../node/bloc/node_bloc.dart';
import '../../../node/models/node_model.dart';

class AboutMousePage extends StatefulWidget {
  const AboutMousePage({Key? key}) : super(key: key);

  @override
  State<AboutMousePage> createState() => _AboutMousePageState();
}

class _AboutMousePageState extends State<AboutMousePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  BlocBuilder<NodeBloc, NodeState>(
        builder: (context, state) {
          return Center(
            child: ListView(
              children: getList(state),
            )

          );
        }
      ),
    );
  }


getList(NodeState state){
    List<Widget> nodeList = [];
    for(int index=0;index<state.nodeModel.length;index++){
      nodeList.add(
       CheckboxListTile(
            title: Text(state.nodeModel[index].country+"--"+state.nodeModel[index].city),
            value: state.currentNodeIndex == index ? true:false,
            onChanged: (value){
              context.read<NodeBloc>().add(
                UpdateNodeIndexEvent(index: index),
              );

            },
          ),
  );
    }
    return nodeList;
}

}
