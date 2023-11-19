import 'package:flutter/material.dart';
import 'calculation.dart';
import 'result_page.dart';
import 'about_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("开关阵列计算器"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
        body: const CalculatePage());
  }
}

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  _CalculatePageState createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Grid Size: ",
                style: TextStyle(fontSize: 24),
              ),
              DropdownButton<int>(
                value: gridSize,
                onChanged: (value) {
                  setState(() {
                    gridSize = value ?? 3;
                  });
                },
                items: List.generate(
                  3,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: SizedBox(
                      width: 50, // 设置宽度
                      child: Text((index + 1).toString()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                  if (pressedIndices.isEmpty) {
                    // 如果 pressedIndices 为空，显示提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('未选择开关'),
                      ),
                    );
                  } else {
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
                  }
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
