import 'package:flutter/material.dart';
import 'calculation.dart';
import 'result_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 在其他平台上不调整窗口大小
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("开关阵列计算器"),
            ),
            body: const MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> pressedIndices = [];
  String result = "Result will be displayed here";
  TextEditingController gridSizeController = TextEditingController();
  int gridSize = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        // Input for grid size
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text("Grid Size: "),
        //       SizedBox(
        //         width: 50,
        //         child: TextField(
        //           controller: gridSizeController,
        //           keyboardType: TextInputType.number,
        //           onChanged: (value) {
        //             setState(() {
        //               gridSize = int.tryParse(value) ?? 3;
        //             });
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Custom Grid Buttons
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            return GridItemButton(
              onPressed: () {
                setState(() {
                  if (pressedIndices.contains(index)) {
                    pressedIndices.remove(index);
                  } else {
                    pressedIndices.add(index);
                  }
                  result = pressedIndices.join(" ");
                });
              },
              index: index + 1,
              isPressed: pressedIndices.contains(index),
            );
          },
        ),
        // Calculate Button
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 38.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200.0, 50.0), // 指定按钮的宽度和高度
                ),
                onPressed: () {
                  // Call the Calculate function from calculation.dart
                  List<int> calculatedResult =
                      calculate(gridSize, pressedIndices);

                  // Update the result based on the calculated result
                  setState(() {
                    result = calculatedResult.join(" ");
                  });

                  // Navigate to the ResultPage with the calculated result
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        stepIndices: calculatedResult,
                        gridSize: gridSize, // 传递正确的 gridSize
                      ),
                    ),
                  );
                },
                child: const Text("Calculate", style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GridItemButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int index;
  final bool isPressed;

  const GridItemButton({
    Key? key,
    required this.onPressed,
    required this.index,
    required this.isPressed,
  }) : super(key: key);

  @override
  _GridItemButtonState createState() => _GridItemButtonState();
}

class _GridItemButtonState extends State<GridItemButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isPressed ? Colors.green : Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "${widget.index}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
