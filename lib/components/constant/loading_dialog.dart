
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKitView extends StatelessWidget {
  final bool themeIsDark;
  final double size;

  const SpinKitView({
    this.themeIsDark = true,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color:  Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitSpinningLines(
            size: size,
            color:  Colors.blue,
          ),
        ],
      ),
    );
  }
}

void showLoadingIndicator(
    {required BuildContext context, bool isDark = false}) {
  showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return  Padding(
        padding: EdgeInsets.all(0),
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SizedBox(
            child: SpinKitCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
          ),
        ),
      );
    },
  );
}

void showLoadingMessage(
    {required BuildContext context,
    bool isDark = false,
    required String message}) {
  showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
              height: 50,
              padding: const EdgeInsets.all(15),
              color: isDark ? Colors.black : Colors.white,
              // width: 50,
              child: FittedBox(
                child: Text(
                     message,

                    ),
              )),
        ),
      );
    },
  );
}

void hideOpenDialog({
  required BuildContext context,
}) {
  Navigator.of(context).pop();
}

Widget spinKitButton(
    BuildContext context, double height, double width, Color color) {
  return Container(
    height: height,
    width: width,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: color),
    child: const Center(
      child:
          // SpinKitFadingCircle(
          SpinKitSpinningLines(
        // SpinKitRipple(
        // SpinKitThreeBounce(
        // child: SpinKitFadingCircle(
        size: 25,
        color: Colors.white,
      ),
    ),
  );
}