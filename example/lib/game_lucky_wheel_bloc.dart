import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:widget_recorder_example/game_lucky_wheel_event.dart';
import 'package:widget_recorder_example/game_lucky_wheel_state.dart';
import 'package:widget_recorder_example/lucky_wheel_setting.dart';
import 'package:widget_recorder_example/player.dart';


class GameLuckyWheelBloc
    extends Bloc<GameLuckyWheelEvent, GameLuckyWheelState> {
  GameLuckyWheelBloc() : super(GameLuckyWheelLoading());

  // final MethodChannel _channel =
  //     MethodChannel('vn.tpos.tposlive/gameLuckyWheel');
  final Logger _logger = Logger();
  late LuckyWheelSetting _luckyWheelSetting;
  bool _isLoadLastWinner = false;
  bool _isLoadPlayer = false;
  bool _userShareApi = true;

  final List<Player> _players = [];

  List<Player> _lastWinners = [];
  final List<Player> _validPlayers = [];
  late Player _winPlayer;

  final List<Player> _sourcePlayers = [];

  @override
  Stream<GameLuckyWheelState> mapEventToState(
      GameLuckyWheelEvent event) async* {
    if (event is GameLuckyWheelLoaded) {
      // _channel.setMethodCallHandler((call) async {
      //   switch (call.method) {
      //     case 'startGame':
      //       _logger.i('gameLuckyWheelInit ${call.arguments}');
      //       try {
      //         add(GameLuckyWheelRecorded());
      //       } catch (e, stack) {
      //         _logger.e('startGame', e.toString(), stack);
      //       }
      //
      //       break;
      //   }
      // });
      yield* _mapLoadToState();
    } else if (event is GameLuckyWheelSnapshotCame) {
      _logger.i('GameLuckyWheelSnapshotCame', event.imageBytes.length);
      // await _channel.invokeMethod('snapshot', {'imageBytes': event.imageBytes});
    } else if (event is GameLuckyWheelStarted) {
      yield* _mapGameLuckyWheelStartedToState(event);
    } else if (event is GameLuckyWheelInitial) {

    } else if (event is GameLuckyWheelRecorded) {
      yield GameLuckyWheelRecordSuccess(state.data);
    }
  }

  Stream<GameLuckyWheelState> _mapGameLuckyWheelStartedToState(
      GameLuckyWheelStarted event) async* {
    if (state.data != null) {
      final List<int> allNumbers = <int>[];
      final DateTime now = DateTime.now();
      // _winPlayer = null;

      for (final Player player in _validPlayers) {
        if (player.id != null) {
          allNumbers.add(player.id!);

          if (!_luckyWheelSetting.isPriority) {
            continue;
          }

          ///Kiểm tra xem người chơi có từng thắng trước đây không, nếu thắng trước đây xem số ngày thắng có nằm trong
          ///ngày của cài đặt không
          if (_luckyWheelSetting.isIgnorePriorityWinner &&
              !_luckyWheelSetting.isSkipWinner &&
              player.lastWinDate != null) {
            final int differentDays =
                now.difference(player.lastWinDate!).inDays;

            if (differentDays <= _luckyWheelSetting.numberSkipDays) {
              continue;
            }
          }

          if (_luckyWheelSetting.isPriorityUnWinner && !player.isWinner) {
            allNumbers.add(player.id!);
          }

          if (_luckyWheelSetting.useShareApi) {
            ///Nếu có chọn share thì ta thêm tỉ lệ tương ứng với số lượng share
            if (_luckyWheelSetting.isPriorityShare && player.shareCount > 0) {
              allNumbers.addAll(List.generate(
                  player.shareCount * _luckyWheelSetting.numberBonusPriority,
                  (genIndex) => player.id!));
            }

            if (_luckyWheelSetting.isPriorityShareGroup) {
              allNumbers.addAll(List.generate(
                  player.groupShareCount *
                      _luckyWheelSetting.numberBonusPriority,
                  (genIndex) => player.id!));
            }
          } else {
            ///Nếu có chọn comment thì ta thêm tỉ lệ tương ứng với số lượng comment
            if (_luckyWheelSetting.isPriorityComment &&
                player.commentCount > 0) {
              allNumbers.addAll(List.generate(
                  player.commentCount * _luckyWheelSetting.numberBonusPriority,
                  (genIndex) => player.id!));
            }
          }
        }
      }

      if (_validPlayers.isNotEmpty) {
        ///random index trong danh sách
        final int randomIndex = Random().nextInt(allNumbers.length);
        _winPlayer = _validPlayers
            .firstWhere((element) => element.id == allNumbers[randomIndex]);

        yield GameLuckyWheelEnd(
          data: state.data!,
          winner: _winPlayer,
        );
      } else {
        yield GameLuckyWheelGameStartError(
          error: 'Không có người chơi',
          data: state.data,
        );
      }
    }
  }

  Future<void> _loadPlayers() async {
    final faker = Faker();

    // randomString(10)
    for (int i in List.generate(10, (index) => index)) {
      _players.add(
        Player(
          name: faker.person.name(),
          id: i,
          dateCreated: DateTime.now(),
          asuId: i.toString(),
          commentCount: 10,
          groupShareCount: 10,
          hasOrder: false,
          isWinner: false,
          lastWinDate: DateTime.now(),
          personalShareCount: 1,
          picture:
              'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg',
          shareCount: 20,
          uId: i.toString(),
        ),
      );
    }

    // if (_luckyWheelSetting.useShareApi) {
    //   _faceBookShareInfoList = await _facebookTPosApi.getShareds(
    //       postId: _postId,
    //       uid: _crmTeam?.facebookId,
    //       teamId: _crmTeam?.id,
    //       mapUid: true);
    //   for (final FacebookShareInfo faceBookShareInfo
    //   in _faceBookShareInfoList) {
    //     if (_players.any(
    //             (Player player) => player.asuId == faceBookShareInfo.from?.id)) {
    //       /// Kiểm tra xem share nhóm hay share cá nhân
    //       final Player player = _players.firstWhere(
    //               (Player item) => item.asuId == faceBookShareInfo.from?.id);
    //
    //       if (faceBookShareInfo.permalinkUrl.contains('/groups') &&
    //           !faceBookShareInfo.permalinkUrl.contains('/posts') &&
    //           !faceBookShareInfo.permalinkUrl.contains('/story_fbid')) {
    //         player.groupShareCount += 1;
    //         player.shareCount += 1;
    //       } else {
    //         player.personalShareCount += 1;
    //         player.shareCount += 1;
    //       }
    //     } else {
    //       final Player player = Player(
    //           asuId: faceBookShareInfo.from?.id,
    //           name: faceBookShareInfo.from?.name,
    //           picture:
    //           'https://graph.facebook.com/${faceBookShareInfo.objectId}/picture?height=320&width=320&access_token=${_crmTeam.userOrPageToken}',
    //           uId: faceBookShareInfo.objectId);
    //
    //       if (faceBookShareInfo.permalinkUrl.contains('/groups') &&
    //           !faceBookShareInfo.permalinkUrl.contains('/posts') &&
    //           !faceBookShareInfo.permalinkUrl.contains('/story_fbid')) {
    //         player.groupShareCount += 1;
    //         player.shareCount += 1;
    //       } else {
    //         player.personalShareCount += 1;
    //         player.shareCount += 1;
    //       }
    //       player.id = _players.length;
    //       _players.add(player);
    //     }
    //   }
    // } else {
    //   _postSummary = await _tposApi.getSaleOnlineFacebookPostSummaryUser(
    //     _postId,
    //     crmTeamId: _crmTeam?.id,
    //   );
    //
    //   _users = _postSummary.users;
    //   for (final Users user in _users) {
    //     _players.add(Player(
    //       asuId: user.id,
    //       commentCount: user.countComment,
    //       shareCount: user.countShare,
    //       hasOrder: user.hasOrder,
    //       uId: user.uId,
    //       picture:
    //       'https://graph.facebook.com/${user.id}/picture?height=320&width=320&access_token=${_crmTeam.userOrPageToken}',
    //       id: _players.length,
    //       name: user.name,
    //     ));
    //   }
    // }
  }

  Future<void> _loadWinners() async {
    // final OdataListResult<TposFacebookWinner> odataListResult =
    // await _tposFacebookApi.getFacebookWinner();
    // _lastWinners.clear();
    // _faceBookWinners = odataListResult.value;
    // for (final TposFacebookWinner facebookWinner in _faceBookWinners) {
    //   _lastWinners.add(Player(
    //       picture:
    //       'https://graph.facebook.com/${facebookWinner.facebookASUId}/picture?height=320&width=320&access_token=$_accessToken',
    //       uId: facebookWinner.facebookUId,
    //       name: facebookWinner.facebookName,
    //       lastWinDate: facebookWinner.dateCreated,
    //       totalDays: facebookWinner.totalDays,
    //       asuId: facebookWinner.facebookASUId));
    //   final Player player = _players.firstWhere(
    //           (Player player) => player.asuId == facebookWinner.facebookASUId,
    //       orElse: () {
    //         return null;
    //       });
    //   if (player != null) {
    //     player.isWinner = true;
    //     player.totalDays = facebookWinner.totalDays;
    //     if (player.picture == null || player.picture == '') {
    //       player.picture =
    //       'https://graph.facebook.com/${facebookWinner.facebookUId}/'
    //           'picture?width=${500}&access_token=$_accessToken';
    //     }
    //   }
    // }
  }

  Stream<GameLuckyWheelState> _mapLoadToState() async* {
    try {
      _luckyWheelSetting = LuckyWheelSetting();
      if (!_isLoadPlayer) {
        _players.clear();
        await _loadPlayers();
        _isLoadPlayer = true;
      }

      if (!_isLoadLastWinner) {
        await _loadWinners();
        _isLoadLastWinner = true;
      }

      _validPlayers.clear();
      _validPlayers.addAll(_players);
      // for (final Player player in _players) {
      //   if (_luckyWheelSetting.isSkipWinner && player.isWinner) {
      //     continue;
      //   }
      //
      //   if (_luckyWheelSetting.useShareApi) {
      //     if (player.shareCount < _luckyWheelSetting.minNumberShare &&
      //         _luckyWheelSetting.isMinShare) {
      //       continue;
      //     }
      //
      //     if (player.groupShareCount < _luckyWheelSetting.minNumberShareGroup &&
      //         _luckyWheelSetting.isMinShareGroup) {
      //       continue;
      //     }
      //   } else {
      //     if (player.commentCount < _luckyWheelSetting.minNumberComment &&
      //         _luckyWheelSetting.isMinComment) {
      //       continue;
      //     }
      //   }
      //
      //   if (_luckyWheelSetting.hasOrder && !player.hasOrder) {
      //     continue;
      //   }
      //
      //   _validPlayers.add(player);
      // }
      //   players: _validPlayers,
      // setting: _luckyWheelSetting,
      // winners: _lastWinners
      yield GameLuckyWheelInitialSuccess(GameLuckyWheelData(
        players: _validPlayers,
        setting: _luckyWheelSetting,
        winners: _lastWinners,
      ));
    } catch (e, stack) {
      _logger.e('GameLuckyWheelLoadFailure', e, stack);
      yield GameLuckyWheelLoadFailure(error: e.toString());
    }
  }
}
