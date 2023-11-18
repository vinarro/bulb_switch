import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final List<int> stepIndices;
  final int gridSize;

  const ResultPage({
    Key? key,
    required this.stepIndices,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("解答："),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text displaying total steps
            Text(
              "一共需要按下 ${stepIndices.length} 次开关",
              style: const TextStyle(fontSize: 18),
            ),
            // Text displaying currently pressed button indices
            Text(
              "分别是第 ${stepIndices.map((index) => index + 1).join("、")} 个开关",
              style: const TextStyle(fontSize: 18),
            ),
            // Grid showing the steps
            StepGrid(
              gridSize: gridSize,
              stepIndices: stepIndices,
            ),
          ],
        ),
      ),
    );
  }
}

class StepGrid extends StatelessWidget {
  final int gridSize;
  final List<int> stepIndices;

  const StepGrid({
    Key? key,
    required this.gridSize,
    required this.stepIndices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int step = 1; step <= stepIndices.length; step++)
          Column(
            children: [
              // Text displaying step number and changed center button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Step $step: 使用开关 ${stepIndices[step - 1] + 1}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              // Grid showing n x n colored blocks
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  return StepBlock(
                    step: step,
                    index: index + 1,
                    stepIndices: stepIndices,
                    gridSize: gridSize,
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}

class StepBlock extends StatelessWidget {
  final int step;
  final int index;
  final List<int> stepIndices;
  final int gridSize;

  const StepBlock({
    Key? key,
    required this.step,
    required this.index,
    required this.stepIndices,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: getBlockColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "$index",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Color getBlockColor() {
    List<Color> colors =
        List.generate(gridSize * gridSize, (index) => Colors.blue);

    // For each step, update the colors
    for (int i = 0; i < step; i++) {
      int pressedIndex = stepIndices[i];
      int row = pressedIndex ~/ gridSize;
      int col = pressedIndex % gridSize;

      // Update current block color
      colors[pressedIndex] = _toggleColor(colors[pressedIndex]);

      // Update adjacent blocks
      updateAdjacentBlocks(colors, row - 1, col); // Up
      updateAdjacentBlocks(colors, row + 1, col); // Down
      updateAdjacentBlocks(colors, row, col - 1); // Left
      updateAdjacentBlocks(colors, row, col + 1); // Right
    }

    return colors[index - 1];
  }

  void updateAdjacentBlocks(List<Color> colors, int row, int col) {
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      int index = row * gridSize + col;
      colors[index] = _toggleColor(colors[index]);
    }
  }

  Color _toggleColor(Color color) {
    return color == Colors.blue ? Colors.red : Colors.blue;
  }
}
