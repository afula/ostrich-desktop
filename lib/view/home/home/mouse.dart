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
  List<DropdownMenuItem<String>> serverDropMenuItem = [];
  String chooseItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  BlocBuilder<NodeBloc, NodeState>(
        builder: (context, state) {
          return Center(
            child: ListView(
              children: getList(state.nodeModel),
            )

          );
        }
      ),
    );
  }


getList(List<NodeModel> nodeModel){
    List<Widget> nodeList = [];
    for(int index=0;index<nodeModel.length;index++){
      nodeList.add(GestureDetector(
        onTap: (){
          print("点击了$index");
          context.read<NodeBloc>().add(
             UpdateNodeIndexEvent(index: index),
          );
        },
        child: Text(nodeModel[index].country+"---"+nodeModel[index].city),
      ));
    }
    return nodeList;
}

}
