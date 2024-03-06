import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  const CustomAppBar({
    Key? key,

  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      left: false,
      right: false,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            
            Text("  ",textScaleFactor: 2),
            Text("M",textScaleFactor: 2),
            Text("T",textScaleFactor: 2),
            Text("O",textScaleFactor: 2),
            Text("T",textScaleFactor: 2),
            Text("F",textScaleFactor: 2),
            Text("L",textScaleFactor: 2),
            Text("S",textScaleFactor: 2),
            
          ],
        ),
      )
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(
    double.maxFinite,
    80
  );
  
}