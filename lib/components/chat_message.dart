import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !mine ?
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ): Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data['senderName'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500
                    
                  ),
                ),
                data['imgFile'] != null ?
                  Image.network(data['imgFile'], width: 250,)
                :
                  Text(
                    data['text'],
                    textAlign: mine ? TextAlign.end : TextAlign.start,                    
                    style: TextStyle(
                      fontSize: 18,
                    )
                  ),
                
              ],
            ),
          ),
          mine ?
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ): Container(),
        ],
      ),
    );
  }
}