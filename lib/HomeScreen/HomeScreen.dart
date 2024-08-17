import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Screens/Login/components/login_screen_top_image.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;

  HomeScreen({required this.fullName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _loginTime = DateTime.now();
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }
  void _logout() {
    // Add your logout logic here
    print('Logging out...');
    // Navigate to the login screen or perform other necessary actions
  }

  @override
  Widget build(BuildContext context) {
    final loginDateString = _loginTime.toLocal().toString().split('.')[0];
    final elapsedMinutes = (_elapsedSeconds / 60).floor();
    final elapsedSeconds = _elapsedSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: defaultPadding * 2),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: SvgPicture.asset("assets/icons/login.svg"),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: defaultPadding * 2),
            Text(
              'Welcome, ${widget.fullName}!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Logged in on:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              loginDateString,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            AnimatedDigitalClock(
              time: Duration(seconds: _elapsedSeconds),
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AnimatedDigitalClock extends StatefulWidget {
  final Duration time;
  final TextStyle style;

  AnimatedDigitalClock({
    required this.time,
    required this.style,
  });

  @override
  _AnimatedDigitalClockState createState() => _AnimatedDigitalClockState();
}

class _AnimatedDigitalClockState extends State<AnimatedDigitalClock>
    with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (widget.time.inSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (widget.time.inSeconds % 60).toString().padLeft(2, '0');

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Text(
            '$minutes:$seconds',
            style: widget.style,
          ),
        );
      },
    );
  }
}