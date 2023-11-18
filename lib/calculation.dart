int switchState(int state, int n, {int size = 3}) {
  int mask = 1 << n;

  if (n % size != 0) {
    mask |= 1 << (n - 1);
  }

  if ((n + 1) % size != 0) {
    mask |= 1 << (n + 1);
  }

  if (n ~/ size != 0) {
    mask |= 1 << (n - size);
  }

  if (n ~/ size != size - 1) {
    mask |= 1 << (n + size);
  }

  return state ^ mask;
}

List<List<int>> minSwitches({int size = 3}) {
  int gridLength = size * size;
  int dpLength = 1 << gridLength;
  List<List<int>> dp = List.generate(dpLength, (_) => []);

  while (dp.skip(1).any((innerList) => innerList.isEmpty)) {
    for (int state = 0; state < dpLength; state++) {
      for (int i = 0; i < gridLength; i++) {
        int newState = switchState(state, i, size: size);
        int newLen = double.maxFinite.toInt();
        int lastLen = double.maxFinite.toInt();
        if (state == 0) {
          lastLen = 0;
        } else if (dp[state].isNotEmpty) {
          lastLen = dp[state].length + 1;
        }
        if (newState == 0) {
          newLen = 0;
        } else if (dp[newState].isNotEmpty) {
          newLen = dp[newState].length;
        }

        if (lastLen < newLen) {
          dp[newState] = [...dp[state], i];
        }
      }
    }
  }

  return dp;
}

List<int> calculate(int gridSize, List<int> pressedIndices) {
  List<List<int>> dp = minSwitches(size: gridSize);
  int mask = 0;

  for (int pressed in pressedIndices) {
    mask |= 1 << pressed;
  }

  return dp[mask];
}
