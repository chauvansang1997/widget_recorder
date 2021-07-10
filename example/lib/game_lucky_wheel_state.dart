

import 'package:widget_recorder_example/lucky_wheel_setting.dart';
import 'package:widget_recorder_example/player.dart';

class GameLuckyWheelData {
  GameLuckyWheelData({
    required this.players,
    required this.winners,
    required this.setting,
  });

  final List<Player> players;
  final List<Player> winners;
  final LuckyWheelSetting setting;

  GameLuckyWheelData copyWith(
      {List<Player>? players,
      List<Player>? winners,
      LuckyWheelSetting? setting}) {
    return GameLuckyWheelData(
      players: players ?? this.players,
      winners: winners ?? this.winners,
      setting: setting ?? this.setting,
    );
  }
}

abstract class GameLuckyWheelState {
  GameLuckyWheelState([this.data]);

  final GameLuckyWheelData? data;
}

class GameLuckyWheelLoading extends GameLuckyWheelState {
  GameLuckyWheelLoading([GameLuckyWheelData? data]) : super(data);
}

class GameLuckyWheelInitialSuccess extends GameLuckyWheelState {
  GameLuckyWheelInitialSuccess(GameLuckyWheelData data) : super(data);

  @override
  String toString() {
    return 'GameLuckyWheelInitialSuccess: data: ${data?.players.length}';
  }
}

class GameLuckyWheelLoadSuccess extends GameLuckyWheelState {
  GameLuckyWheelLoadSuccess(GameLuckyWheelData data) : super(data);
}

class GameLuckyWheelRecordSuccess extends GameLuckyWheelState {
  GameLuckyWheelRecordSuccess(GameLuckyWheelData? data) : super(data);
}

class GameLuckyWheelEnd extends GameLuckyWheelState {
  GameLuckyWheelEnd({required this.winner, required GameLuckyWheelData data})
      : super(data);

  final Player winner;
}

class GameLuckyWheelError extends GameLuckyWheelState {
  GameLuckyWheelError({required this.error, GameLuckyWheelData? data})
      : super(data);

  final String error;
}

class GameLuckyWheelLoadFailure extends GameLuckyWheelError {
  GameLuckyWheelLoadFailure({required String error, GameLuckyWheelData? data})
      : super(data: data, error: error);
}

class GameLuckyWheelGameStartError extends GameLuckyWheelError {
  GameLuckyWheelGameStartError({
    required String error,
    GameLuckyWheelData? data,
  }) : super(data: data, error: error);
}
