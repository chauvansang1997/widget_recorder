import 'dart:typed_data';

abstract class GameLuckyWheelEvent {}

class GameLuckyWheelLoaded extends GameLuckyWheelEvent {}

class GameLuckyWheelInitial extends GameLuckyWheelEvent {}

class GameLuckyWheelStarted extends GameLuckyWheelEvent {}

class GameLuckyWheelRecorded extends GameLuckyWheelEvent {}

class GameLuckyWheelSnapshotCame extends GameLuckyWheelEvent {
  GameLuckyWheelSnapshotCame(this.imageBytes);

  final Uint8List imageBytes;
}


