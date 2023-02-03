import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class FullPhotoViewPage extends StatefulWidget{
  final String? photoUrl;
  FullPhotoViewPage({Key? key, @required this.photoUrl}) : super(key: key);
  @override
  State<StatefulWidget> createState() => FullPhotoViewState();


}

class FullPhotoViewState extends State<FullPhotoViewPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarOpacity: 0,
        toolbarHeight: 0.0,
        brightness: Brightness.dark,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
              child: PhotoView(
                imageProvider: NetworkImage(widget.photoUrl!),
              )
          ),
          Align(
            child: Padding(padding: EdgeInsets.all(20),
              child:  InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                  child: Icon(Icons.arrow_back,color: Colors.white,),
                  padding: EdgeInsets.all(6),
                ),
              ),
            ),
            alignment: Alignment.topLeft,
          ),

        ],
      ),
    );
  }

  /*Future<void> share() async {
    await FlutterShare.share(
      title: 'Share dog image to your contact',
      linkUrl: widget.photoUrl,
    );
  }*/

}





