import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => CounterState();
}

class CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          icon: const Icon(Icons.add),
        ),
        Text(
          count.toString(),
        ),
      ],
    );
  }
}

class Demo extends StatefulWidget {
  final GlobalKey<CounterState> counterKey;
  const Demo({required this.counterKey, super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Center(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.counterKey.currentState!.count++;
                });
              },
            ),
            Text(
              widget.counterKey.currentState!.count.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final GlobalKey<CounterState> counterState = GlobalKey<CounterState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: Column(
        children: [
          Counter(
            key: counterState,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (builder) => Demo(counterKey: counterState),
                ),
              );
            },
            icon: const Icon(Icons.arrow_circle_right),
          ),
        ],
      ),
    );
  }
}
