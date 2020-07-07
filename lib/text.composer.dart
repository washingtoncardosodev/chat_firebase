import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  
  TextComposer(this.sendMessage);

  final Function({String text, File imgFile}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  bool _isComposing = false;
  final TextEditingController _msgController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);
  //   _image = File(pickedFile.path);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera), 
            onPressed: () async {
              final pickedFile = await this.picker.getImage(source: ImageSource.camera);
              this._image = File(pickedFile.path);
              if (this._image == null) {
                return;
              } else {
                widget.sendMessage(imgFile: this._image);
              }
            }
          ),
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
              onChanged: (text){
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text){
                widget.sendMessage(text: text);
                _reset();
              },
            )
          ),
          IconButton(
            icon: Icon(Icons.send), 
            onPressed: _isComposing ? (){
              widget.sendMessage(text: _msgController.text);
              _reset();
            } : null
          )
        ]
      )
    );
  }

  void _reset() {
    _msgController.clear();
    setState(() {
      _isComposing = false;
    });
  }
}