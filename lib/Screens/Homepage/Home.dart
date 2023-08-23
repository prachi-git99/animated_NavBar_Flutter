import 'package:flutter/material.dart';
import 'package:work_with_animations/widgets/NavBar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  double horizontalPadding = 50.0;
  double horizontalMargin = 20.0;

  int noOFicons = 3;

  late double position;

  List<String> icons = [
    'assets/images/home.png',
    'assets/images/user.png',
    'assets/images/settings.png',
  ];



  late AnimationController controller;
  late Animation<double> animation;

  int selected = 0;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 375));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    animation = Tween(begin: getEndPosition(0), end: getEndPosition(2)).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    position = getEndPosition(0);

    super.didChangeDependencies();
  }

  double getEndPosition(int index) {
    double totalMargin = 2 * horizontalMargin;
    double totalPadding = 2 * horizontalPadding;
    double valueToOmit = totalMargin + totalPadding;
    return (((MediaQuery.of(context).size.width - valueToOmit) / noOFicons) *
                index +
            horizontalPadding) +
        (((MediaQuery.of(context).size.width - valueToOmit) / noOFicons) / 2) -
        70.0;
  }

  void animateDrop(int index) {
    animation = Tween(begin: position, end: getEndPosition(index)).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack));
    controller.forward().then((value) {
      position = getEndPosition(index);
      controller.dispose();
      controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 375));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(child:AnimatedContainer(
          duration: Duration(milliseconds: 375),
          curve: Curves.easeOut,
          color: Colors.blue,
        )),
        Positioned(
            bottom: horizontalMargin,
            left: horizontalMargin,
            child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: AppBarPainter(animation.value),
                    size: Size(
                        MediaQuery.of(context).size.width -
                            (2 * horizontalMargin),
                        80.0),
                    child: SizedBox(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width -
                          (2 * horizontalMargin),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row(
                          children: icons.map<Widget>((icon) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  animateDrop(icons.indexOf(icon));
                                  selected = icons.indexOf(icon);
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 575),
                                curve: Curves.easeOut,
                                height: 105.0,
                                width: (MediaQuery.of(context).size.width -
                                        (2 * horizontalMargin) -
                                        (2 * horizontalPadding)) /
                                    3,
                                padding:
                                    EdgeInsets.only(bottom: 17.5, top: 22.5),
                                // color: icons.indexOf(icon) % 2 == 0
                                //     ? Colors.amber.withOpacity(0.5)
                                //     : Colors.red.withOpacity(0.5),
                                alignment: selected == icons.indexOf(icon)
                                    ? Alignment.topCenter
                                    : Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 35.0,
                                  width: 35.0,
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 375),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeOut,
                                      child: selected == icons.indexOf(icon)
                                          ? Image.asset(
                                              icon,
                                              width: 30.0,
                                              color: Colors.yellow,
                                              key: ValueKey('yellow$icon'),
                                            )
                                          : Image.asset(icon,
                                              width: 30.0,
                                              color: Colors.white,
                                              key: ValueKey('white$icon')),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                }))
      ],
    ));
  }
}

class AppBarPainter extends CustomPainter {
  double x;

  AppBarPainter(this.x);

  double height = 80.0;
  double start = 40.0;
  double end = 120.0;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0.0, start);

    path.lineTo((x) < 20.0 ? 20.0 : x, start);

    path.quadraticBezierTo(20.0 + x, start, 30.0 + x, start + 30.0);
    path.quadraticBezierTo(40.0 + x, start + 55.0, 70.0 + x, start + 55.0);
    path.quadraticBezierTo(100.0 + x, start + 55.0, 110.0 + x, start + 30.0);
    path.quadraticBezierTo(
        120.0 + x,
        start,
        (140.0 + x) > (size.width - 20.0) ? (size.width - 20.0) : 140.0 + x,
        start);

    path.lineTo(size.width - 20.0, start);

    path.quadraticBezierTo(size.width, start, size.width, start + 25.0);
    path.lineTo(size.width, end - 25.0);
    path.quadraticBezierTo(size.width, end, size.width - 25.0, end);
    path.lineTo(25.0, end);
    path.quadraticBezierTo(0.0, end, 0.0, end - 25.0);
    path.lineTo(0.0, start + 25.0);
    path.quadraticBezierTo(0.0, start, 20.0, start);
    path.close();

    canvas.drawPath(path, paint); //drawing curves

    canvas.drawCircle(Offset(70.0 + x, 50.0), 35.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
