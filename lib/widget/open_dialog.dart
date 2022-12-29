// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// ///自定义Dialog
// class CustomDialog extends StatefulWidget {
//   //------------------不带图片的dialog------------------------
//   final String title; //弹窗标题
//   final String confirmContent; //按钮文本
//   final bool isCancel; //是否有取消按钮，默认为true true：有 false：没有
//   final bool outsideDismiss; //点击弹窗外部，关闭弹窗，默认为true true：可以关闭 false：不可以关闭
//   final Function confirmCallback; //点击确定按钮回调
//   final Function dismissCallback; //弹窗关闭回调

//   const CustomDialog({
//     required this.title,
//     required this.confirmContent,
//     this.isCancel = true,
//     this.outsideDismiss = true,
//     required this.confirmCallback,
//     required this.dismissCallback,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return _CustomDialogState();
//   }
// }

// class _CustomDialogState extends State<CustomDialog> {
//   final TextEditingController _adminPasswdController = TextEditingController();
//   var noPasswdTip = "";
//   bool isSave = true;

//   _confirmDialog() {
//     Map<String, dynamic> value = {
//       "passwd": _adminPasswdController.text,
//       "save": isSave
//     };
//     if (_adminPasswdController.text == "") {
//       EasyLoading.showToast("密码不能为空！");
//       return;
//     }
//     widget.confirmCallback(value);
//     Navigator.of(context).pop();
//   }

//   _dismissDialog() {
//     widget.dismissCallback();
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Column _columnText = Column(
//       children: <Widget>[
//         const SizedBox(height: 16.0),
//         Text(widget.title,
//             style:
//                 const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
//         Expanded(
//             child: Center(
//                 child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.fromLTRB(18, 42, 18, 0),
//                   child: TextField(
//                     decoration: const InputDecoration(
//                       labelText: '请输入管理员密码',
//                       prefixIcon: Icon(Icons.account_circle),
//                       labelStyle: TextStyle(color: Colors.grey),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0x00FF0000)),
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0x00000000)),
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       fillColor: Color(0x30cccccc),
//                       filled: true,
//                     ),
//                     obscureText: true,
//                     controller: _adminPasswdController,
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     const Text(
//                       "记住密码：",
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(0, 4, 18, 0),
//                       child: Checkbox(
//                         value: isSave,
//                         activeColor: Colors.blue,
//                         onChanged: (value) {
//                           setState(() {
//                             isSave = !isSave;
//                           });
//                         },
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             )),
//             flex: 1),
//         SizedBox(height: 1.0, child: Container(color: Color(0xDBDBDBDB))),
//         Container(
//             height: 45,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                     child: Container(
//                       decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(12.0))),
//                       child: FlatButton(
//                         child: const Text('取消',
//                             style: TextStyle(
//                               fontSize: 16.0,
//                             )),
//                         onPressed: _dismissDialog,
//                       ),
//                     ),
//                     flex: widget.isCancel ? 1 : 0),
//                 SizedBox(
//                     width: widget.isCancel ? 1.0 : 0,
//                     child: Container(color: Color(0xDBDBDBDB))),
//                 Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           borderRadius: widget.isCancel
//                               ? BorderRadius.only(
//                                   bottomRight: Radius.circular(12.0))
//                               : BorderRadius.only(
//                                   bottomLeft: Radius.circular(12.0),
//                                   bottomRight: Radius.circular(12.0))),
//                       child: FlatButton(
//                         onPressed: _confirmDialog,
//                         child: Text(widget.confirmContent,
//                             style: const TextStyle(
//                               fontSize: 16.0,
//                             )),
//                       ),
//                     ),
//                     flex: 1),
//               ],
//             ))
//       ],
//     );

//     return Material(
//       type: MaterialType.transparency,
//       child: Center(
//         child: Container(
//           width: 360,
//           height: 240.0,
//           alignment: Alignment.center,
//           child: _columnText,
//           decoration: BoxDecoration(
//               color: const Color(0xFFFFFFFF),
//               borderRadius: BorderRadius.circular(12.0)),
//         ),
//       ),
//     );
//   }
// }
