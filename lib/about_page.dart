import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "开关阵列计算器",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Version: 1.0.0",
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "这是一个平平无奇的计算器, 为了帮助某人解决数学试卷第17题所编写.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "规则大致如下: 一个 3x3 的开关阵列, 每次切换一个开关时, 与其相邻的上下左右开关也会改变状态. 目标是求出从所有开关关闭的初始状态转变为目标状态最小步骤和次数.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text("To: Q"),
            ),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text("Developer: V"),
            ),
            ListTile(
              leading: Icon(Icons.developer_board),
              title: Text("Power By: Flutter"),
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: FittedBox(
                fit: BoxFit.scaleDown, // 缩小以适应约束框
                child: Text(
                  "https://github.com/vinarro/bulb_switch",
                  style: TextStyle(fontSize: 20), // 初始字体大小
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
