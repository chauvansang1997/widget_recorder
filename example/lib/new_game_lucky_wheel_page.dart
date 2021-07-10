import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:widget_recorder/widget_recorder.dart';
import 'package:widget_recorder_example/app_button.dart';
import 'package:widget_recorder_example/background/animate_overlap.dart';
import 'package:widget_recorder_example/background/lucky_wheel_background.dart';
import 'package:widget_recorder_example/game_lucky_wheel_bloc.dart';
import 'package:widget_recorder_example/game_lucky_wheel_event.dart';
import 'package:widget_recorder_example/game_lucky_wheel_state.dart';
import 'package:widget_recorder_example/lucky_wheel_setting.dart';
import 'package:widget_recorder_example/player.dart';

class NewGameLuckyWheelPage extends StatefulWidget {
  const NewGameLuckyWheelPage({Key? key}) : super(key: key);

  @override
  _NewGameLuckyWheelPageState createState() => _NewGameLuckyWheelPageState();
}

class _NewGameLuckyWheelPageState extends State<NewGameLuckyWheelPage> {
  late GameLuckyWheelBloc _gameLuckyWheelBloc;
  final OverlapController _overlapController = OverlapController();
  List<Player> _players = [];
  List<Player> _displayPlayers = [];
  List<Player> _winners = [];
  final ScrollController _playerController = ScrollController();
  final ScrollController _numberPlayerController = ScrollController();
  final ScrollController _numberShareController = ScrollController();
  final ScrollController _numberCommentController = ScrollController();

  // final ConfettiController _controllerTopCenter =
  //     ConfettiController(duration: const Duration(seconds: 3));
  int _totalShare = 0;
  int _totalComment = 0;
  final double _itemHeight = 120;
  final Duration _duration = const Duration(milliseconds: 5000);
  bool _isPlaying = false;
  late LuckyWheelSetting _luckyWheelSetting;
  final BackgroundPainterController _painterController =
      BackgroundPainterController();
  final _NameController _startController = _NameController();
  double _transform = 0;
  late WidgetRecorderPeriodicController _recordController;
  Uint8List? _imageBytes;

  void notifyNewFrameReady() {
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) {
      print('new');
      _recordController.newFrameReady();
    });
  }

  @override
  void initState() {
    _recordController = WidgetRecorderPeriodicController(
      delay: Duration(milliseconds: 20),
      pixelRatio: 1,
      scaleFactor: 1
    );
    _recordController.addListener(notifyNewFrameReady);
    _gameLuckyWheelBloc = GameLuckyWheelBloc();
    _gameLuckyWheelBloc.add(GameLuckyWheelLoaded());
    // _gameLuckyWheelBloc.add(GameLuckyWheelLoaded(
    //     token: widget.crmTeam.userOrPageToken,
    //     crmTeam: widget.crmTeam,
    //     postId: widget.postId,
    //   ),
    // );
    super.initState();
  }

  @override
  void dispose() {
    _recordController.dispose();
    _playerController.dispose();
    _numberPlayerController.dispose();
    _numberShareController.dispose();
    _numberCommentController.dispose();
    _gameLuckyWheelBloc.close();
    _painterController.dispose();
    // _controllerTopCenter.dispose();
    _overlapController.dispose();
    super.dispose();
  }

  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = new Random();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff198827),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _recordController.start();
              // WidgetsBinding.instance?.addPostFrameCallback(
              //     (_) => _painterController.playLoopAnimation());
            },
            child: WidgetRecorder(
              controller: _recordController,
              onSnapshotTaken: (WidgetRecorderSnapshot? snapshot) {
                if (snapshot != null) {
                  index = random.nextInt(3);
                  print(snapshot);

                  Uint8List bytes = snapshot.byteData.buffer.asUint8List();
                  print(bytes.length);
                  // _gameLuckyWheelBloc.add(GameLuckyWheelSnapshotCame(bytes));
                  setState(() {
                    _imageBytes = bytes;
                  });
                }
              },
              child: Transform(
                transform: Matrix4.rotationY(_transform),
                alignment: Alignment.center,
                child: _buildBody(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _recordController.start();
              // WidgetsBinding.instance?.addPostFrameCallback(
              //     (_) => _painterController.playLoopAnimation());
            },
            child: Container(
              width: 200,
              height: 200,
              color: colors[index],
              child: FittedBox(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: _imageBytes == null
                      ? const SizedBox()
                      : Image.memory(_imageBytes!, gaplessPlayback: true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CircleButton(
          icon: SvgPicture.asset('assets/icons/close.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Row(
          children: [
            _CircleButton(
              onPressed: () {
                // _gameLuckyWheelBloc.add(GameLuckyWheelRefreshed());
              },
              icon: SvgPicture.asset('assets/icons/refresh.svg'),
            ),
            const SizedBox(width: 12),
            _CircleButton(
              icon: SvgPicture.asset('assets/icons/win.svg'),
              onPressed: () async {
                // final List<Player> players = await showDialog<dynamic>(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return GameLuckyWinnerPage(
                //       args: LuckyWheelGameV2WinnerPlayerArgs(
                //         winners: _winners,
                //         pageAccessToken: widget.crmTeam.facebookTypeId == 'Page'
                //             ? widget.crmTeam.userOrPageToken
                //             : null,
                //       ),
                //     );
                //   },
                //   useRootNavigator: false,
                // );
                // if (players != null) {
                //   print(players.length);
                //   _gameLuckyWheelBloc
                //       .add(GameLuckyWheelWinnerUpdateLocal(players: players));
                // }
              },
            ),
            const SizedBox(width: 12),
            _CircleButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () async {
                // final LuckyWheelSetting luckyWheelSetting =
                //     await Navigator.push(context,
                //         MaterialPageRoute(builder: (context) {
                //   return LuckyWheelSettingPage(
                //     luckyWheelSetting: _luckyWheelSetting,
                //   );
                // }));
                // if (luckyWheelSetting != null) {
                //   _gameLuckyWheelBloc.add(GameLuckyWheelSaveConfig(
                //       luckyWheelSetting: luckyWheelSetting));
                // }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody() {
    return LuckyWheelBackground(
      child: BlocConsumer<GameLuckyWheelBloc, GameLuckyWheelState>(
        bloc: _gameLuckyWheelBloc,
        listener: (BuildContext context, GameLuckyWheelState state) async {
          if (state is GameLuckyWheelEnd) {
            final data = state.data;
            if (data != null) {
              _scrollToElement(
                data.setting.timeInSecond,
                data.players.indexOf(state.winner),
              );
            }
          } else if (state is GameLuckyWheelRecordSuccess) {
            _recordController.start();
            // WidgetsBinding.instance?.addPostFrameCallback(
            //         (_) => _painterController.playLoopAnimation());
          } else if (state is GameLuckyWheelInitialSuccess) {
            // _isPlaying = true;
            final data = state.data;
            if (data != null) {
              WidgetsBinding.instance?.addPostFrameCallback(
                  (_) => _painterController.playAnimation());
              _players = data.players;
              _displayPlayers = List.from(_players);

              if (_displayPlayers.length == 1) {
                _displayPlayers.add(_players.first);
                _displayPlayers.add(_players.first);
              } else if (_displayPlayers.length == 2) {
                _displayPlayers.add(_players.first);
              }

              _winners = data.winners;
              _totalShare = _players.fold(
                  0,
                  (int previous, Player current) =>
                      previous + current.shareCount);
              _totalComment = _players.fold(
                  0,
                  (int previous, Player current) =>
                      previous + current.commentCount);
              if (_players.isNotEmpty) {
                WidgetsBinding.instance?.addPostFrameCallback((_) =>
                    _numberPlayerController.animateTo(
                        (_players.length - 1) * 30.0,
                        duration: const Duration(milliseconds: 5000),
                        curve: Curves.easeOut));
              }

              if (_totalShare > 0) {
                WidgetsBinding.instance?.addPostFrameCallback((_) =>
                    _numberShareController.animateTo((_totalShare - 1) * 30.0,
                        duration: const Duration(milliseconds: 5000),
                        curve: Curves.easeOut));
              }
              if (_totalComment > 0) {
                WidgetsBinding.instance?.addPostFrameCallback((_) =>
                    _numberCommentController.animateTo(
                        (_totalComment - 1) * 30.0,
                        duration: const Duration(milliseconds: 5000),
                        curve: Curves.easeOut));
              }
            }
          }
        },
        builder: (BuildContext context, GameLuckyWheelState state) {
          final data = state.data;
          if (data != null) {
            _luckyWheelSetting = data.setting;
            _winners = data.winners;
            _players = data.players;
            _displayPlayers = List.from(_players);

            if (_displayPlayers.length == 1) {
              _displayPlayers.add(_players.first);
              _displayPlayers.add(_players.first);
            } else if (_displayPlayers.length == 2) {
              _displayPlayers.add(_players.first);
            }
            _totalShare = _players.fold(
                0,
                (int previous, Player current) =>
                    previous + current.shareCount);
            _totalComment = _players.fold(
                0,
                (int previous, Player current) =>
                    previous + current.commentCount);
            final double aspectHeight =
                MediaQuery.of(context).size.height / 800;
            return LuckyWheelBackground(
              painterController: _painterController,
              backgroundColor: const Color(0xff198827),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 10 * aspectHeight),
                      _buildAppBar(),
                      SizedBox(height: 15 * aspectHeight),
                      _buildGameName(),
                      SizedBox(height: 20 * aspectHeight),
                      _buildStatics(),
                      SizedBox(height: 11 * aspectHeight),
                      Expanded(
                          child: _displayPlayers.isNotEmpty
                              ? _buildScrollList()
                              : _buildEmpty()),
                      SizedBox(height: 20 * aspectHeight),
                      if (_displayPlayers.isNotEmpty && !_isPlaying)
                        _buildButton()
                      else
                        _buildDisableButton(),
                      SizedBox(height: 10 * aspectHeight),
                      _buildBottom(),
                      SizedBox(height: 10 * aspectHeight),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  ///Xây dựng giao diện  tên game
  Widget _buildGameName() {
    final double aspectHeight = MediaQuery.of(context).size.height / 800;
    return _StartAnimationNameWidget(
      nameController: _startController,
      duration: const Duration(milliseconds: 5000),
      numberLoop: 3,
      angle: 15,
      child: Container(
        height: 122 * aspectHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          image: DecorationImage(
              image: AssetImage(
                'images/vxmm.png',
                // package: 'tpos_lucky_wheel_game',
              ),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

  ///Xây dựng giao diện thống kê số người chơi, số lượt chia sẻ, số nhận xét
  Widget _buildStatics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Colors.white.withOpacity(0.13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return LuckyWheelPlayerPage(
                //     players: _players,
                //   );
                // }));
              },
              child: Container(
                height: 30,
                child: _displayPlayers.isNotEmpty
                    ? ListWheelScrollView.useDelegate(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _numberPlayerController,
                        onSelectedItemChanged: (int value) {},
                        itemExtent: 30,
                        diameterRatio: 100,
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(
                                  _displayPlayers.length, (index) => index + 1)
                              .map((int index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/person.svg'),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          index.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/person.svg'),
                          const SizedBox(width: 5),
                          const Flexible(
                            child: Text(
                              '0',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 30,
              child: _totalShare > 0
                  ? ListWheelScrollView.useDelegate(
                      controller: _numberShareController,
                      onSelectedItemChanged: (int value) {},
                      itemExtent: 30,
                      diameterRatio: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children: List.generate(
                                _totalShare, (index) => index + 1)
                            .map((int index) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/share.svg'),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        index.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/share.svg'),
                        const SizedBox(width: 5),
                        const Flexible(
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Flexible(
            child: Container(
              height: 30,
              child: _totalComment > 0
                  ? ListWheelScrollView.useDelegate(
                      controller: _numberCommentController,
                      onSelectedItemChanged: (int value) {},
                      itemExtent: 30,
                      diameterRatio: 100,
                      physics: const NeverScrollableScrollPhysics(),
                      childDelegate: ListWheelChildLoopingListDelegate(
                        children:
                            List.generate(_totalComment, (index) => index + 1)
                                .map((int index) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/comment.svg'),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            index.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/comment.svg'),
                        const SizedBox(width: 5),
                        const Flexible(
                          child: Text(
                            '0',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  ///Nút quay
  Widget _buildButton() {
    return InkWell(
      onTap: () {
        _isPlaying = true;
        _gameLuckyWheelBloc.add(GameLuckyWheelStarted());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 40, right: 40),
        height: 65,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/game/icon/ic_button_turned.png'),
                fit: BoxFit.scaleDown)),
      ),
    );
  }

  ///Nút xoay khi không có người chơi
  Widget _buildDisableButton() {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40),
      height: 65,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image:
                  AssetImage('assets/game/icon/ic_disable_button_turned.png'),
              fit: BoxFit.scaleDown)),
    );
  }

  ///Danh sách ngưởi chơi
  Widget _buildScrollList() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: double.infinity,
          height: 300,
          padding:
              const EdgeInsets.only(left: 9, right: 9, top: 18, bottom: 18),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: Colors.white.withOpacity(0.13),
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: [
              ListWheelScrollView.useDelegate(
                key: const ValueKey<String>('gameList'),
                physics: const NeverScrollableScrollPhysics(),
                controller: _playerController,
                diameterRatio: 100,
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: _displayPlayers
                      .asMap()
                      .entries
                      .map(
                        (MapEntry<int, Player> entry) => Hero(
                          tag:
                              "hero_${entry.value.id}_${entry.value.uId}_${entry.key}",
                          child: _PlayerItem(
                              key: ValueKey<int>(entry.key),
                              player: entry.value,
                              height: _itemHeight),
                        ),
                      )
                      .toList(),
                ),
                itemExtent: 120,
              ),
              Positioned(
                right: -10,
                top: constraints.maxHeight / 2 - 36,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    "assets/icons/game_wheel_arrow.svg",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///xây dựng giao diện trống
  Widget _buildEmpty() {
    final double aspectHeight = MediaQuery.of(context).size.height / 800;
    final double aspectWidth = MediaQuery.of(context).size.width / 360;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: [
            ClipRRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(19)),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  padding: EdgeInsets.only(
                      left: 40 * aspectWidth, right: 40 * aspectWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/game/icon/no_player.png',
                        width: 140 * aspectWidth,
                        height: 140 * aspectWidth,
                      ),
                      const Opacity(
                        opacity: 0.73,
                        child: Text(
                          'Chưa có người chơi nào, mời thêm khách hàng xem live của bạn hoặc tải lại trang.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      SizedBox(height: 20 * aspectHeight),
                      AppButton(
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          // _gameLuckyWheelBloc.add(GameLuckyWheelLoaded(
                          //     token: widget.crmTeam.userOrPageToken,
                          //     crmTeam: widget.crmTeam,
                          //     postId: widget.postId));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/refresh.svg'),
                            const SizedBox(width: 10),
                            const Text(
                              'Tải lại',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20 * aspectHeight),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -16,
              child: Container(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  "assets/icons/game_wheel_arrow.svg",
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Xaay dựng nút ở dưới màn hình nút quay màn hình, nút hướng dẫn
  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildRotateScreenButton(), _buildInstructionButton()],
    );
  }

  ///Nút quay màn hình
  Widget _buildRotateScreenButton() {
    return InkWell(
      onTap: () {
        setState(() {
          if (_transform == pi) {
            _transform = 0;
          } else {
            _transform = pi;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/rotate_screen.svg'),
            const SizedBox(width: 8),
            const Text('Xoay màn hình',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  ///Nút hướng dẫn
  Widget _buildInstructionButton() {
    return InkWell(
      onTap: () {
        // showTutorial(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/instruction.svg'),
            const SizedBox(width: 8),
            const Text('Hướng dẫn',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
      ),
    );
  }

  ///Dialog người trúng thưởng
  Widget _buildWinnerDialog(Player player, [int playerIndex = 0]) {
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _overlapController.open());
    return BlocBuilder<GameLuckyWheelBloc, GameLuckyWheelState>(
        bloc: _gameLuckyWheelBloc,
        // loadingState: GameLuckyWheelLoading,
        // errorState: GameLuckyWheelLoadFailure,
        // busyState: GameLuckyWheelBusy,
        builder: (BuildContext context, GameLuckyWheelState state) {
          return Padding(
            padding: const EdgeInsets.only(top: 120),
            child: SingleChildScrollView(
              child: AnimateOverlay(
                duration: const Duration(milliseconds: 400),
                overlapController: _overlapController,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _overlapController.close();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      _CircleButton(
                                        icon: SvgPicture.asset(
                                            'assets/icons/messenger.svg'),
                                        onPressed: () {
                                          // _gameLuckyWheelBloc.add(
                                          //     GameLuckyWheelPlayerShared(
                                          //         winner: player));
                                          // Navigator.of(context).pop();
                                        },
                                        backgroundColor: Colors.white,
                                      ),
                                      const SizedBox(width: 13),
                                      _CircleButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          // _overlapController.playReverse();
                                          Navigator.of(context).pop();
                                          _overlapController.close();
                                        },
                                        backgroundColor: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildWinner(player, state, playerIndex)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimateOverlayListener(
                    overlapController: _overlapController,
                    builder:
                        (BuildContext context, Animation<double>? animation) {
                      if (animation == null) {
                        return Positioned(
                          left: 0,
                          right: 0,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 200,
                          child: SvgPicture.asset(
                              'assets/icons/congratulation.svg'),
                        );
                      }
                      final Animation scaleAnimation =
                          Tween(begin: 2.0, end: 1.0).animate(animation);

                      return AnimatedBuilder(
                        builder: (context, child) {
                          return Positioned(
                            left: 0,
                            right: 0,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 200,
                            child: Transform.scale(
                                scale: scaleAnimation.value, child: child),
                          );
                        },
                        animation: animation,
                        child:
                            SvgPicture.asset('assets/icons/congratulation.svg'),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildWinner(Player player, GameLuckyWheelState state,
      [int playerIndex = 0]) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
      ),
      // padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CachedNetworkImage(
              width: double.infinity,
              height: 238,
              fit: BoxFit.cover,
              imageUrl: player.picture ?? '',
              placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 238,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const SizedBox()),
              imageBuilder:
                  (BuildContext context, ImageProvider imageProvider) {
                return Container(
                  width: double.infinity,
                  height: 238,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      shape: BoxShape.circle),
                );
              },
              errorWidget: (context, url, error) => Image.asset(
                "images/no_image.png",
                width: double.infinity,
                height: 238,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              player.name ?? '',
              style: const TextStyle(fontSize: 23, color: Color(0xff2C333A)),
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/share.svg',
                  color: const Color(0xffCBD1D8),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    player.shareCount.toString(),
                    style:
                        const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                  ),
                ),
                const SizedBox(width: 20),
                SvgPicture.asset('assets/icons/comment.svg',
                    color: const Color(0xffCBD1D8)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    player.commentCount.toString(),
                    style:
                        const TextStyle(color: Color(0xff6b7280), fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffF0F1F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FlatButton(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: const Center(
                        child: Text(
                          'In phiếu',
                          style:
                              TextStyle(color: Color(0xff3A3B3F), fontSize: 17),
                        ),
                      ),
                      onPressed: () {
                        // _gameLuckyWheelBloc.add(GameLuckyWheelWinnerPrinted());
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Flexible(
                //   child: Container(
                //     height: 50,
                //     decoration: BoxDecoration(
                //         color: const Color(0xff28A745),
                //         borderRadius: BorderRadius.circular(8),
                //         border: Border.all(
                //             color: const Color(0xff28A745), width: 1)),
                //     child: FlatButton(
                //       padding: const EdgeInsets.only(left: 0, right: 0),
                //       child: Center(
                //         child: state is GameLuckyWheelWinnerSaving
                //             ? Transform.scale(
                //                 scale: 0.5,
                //                 child: const LoadingIndicator(
                //                   backgroundColor: Colors.transparent,
                //                   loadingColor: Colors.white,
                //                 ),
                //               )
                //             : const Text(
                //                 'Lưu',
                //                 style: TextStyle(
                //                     color: Colors.white, fontSize: 17),
                //               ),
                //       ),
                //       onPressed: state is GameLuckyWheelWinnerSaving
                //           ? null
                //           : () {
                //               _gameLuckyWheelBloc
                //                   .add(GameLuckyWheelWinnerSaved());
                //             },
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///di chuyển tới người trúng thưởng
  Future<void> _scrollToElement(int second, int playerIndex) async {
    /// Thời gian bắt đầu giảm vận tốc
    ///const double gameDurationReduce = 10;
    const int numberReverseLoop = 20;
    const int partMove = 10;

    /// Vận tốc
    const double speed = 100;

    /// Loop 60ms
    const double gameLoop = 17;

    /// Độ cao một item
    final double itemHeight = _itemHeight;

    /// Số vòng lặp
    final double gameTime = second * 1000 / gameLoop;

    /// Khoảng cách
    final double distance = gameTime * (speed / 2);

    /// Bước lùi
    final double speedStep = speed / gameTime;

    /// Vị trí dừng
    final double endOffset = itemHeight * playerIndex;

    /// Vị trí khởi đầu
    final double startOffset = endOffset - distance - 50;

    /// Vị trí hiện tại
    double tempOffset = startOffset;

    /// Vận tốc hiện tại
    double tempSpeed = speed;

    ///khởi động lấy đà
    for (final int i in List<int>.generate(numberReverseLoop, (i) => i + 1)) {
      _playerController.jumpTo((_itemHeight / partMove) * i);
      await Future.delayed(const Duration(milliseconds: 25));
    }

    ///di chuyển trở lại vị trí cũ
    for (final int i
        in List<int>.generate(numberReverseLoop, (i) => i + 1).reversed) {
      _playerController.jumpTo(-(_itemHeight / partMove) * i);
      await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
    }

    /// loop
    while (tempSpeed > 0) {
      _playerController.jumpTo(tempOffset);
      await Future.delayed(Duration(milliseconds: gameLoop.toInt()));
      tempOffset += tempSpeed;
      tempSpeed -= speedStep;
    }

    Navigator.of(context, rootNavigator: true)
        .push<dynamic>(_HeroDialogRoute<dynamic>(
      builder: (BuildContext context) {
        return _buildWinnerDialog(_players[playerIndex], playerIndex);
      },
    ));

    if (_luckyWheelSetting.saveWhenFinished) {
      // _gameLuckyWheelBloc.add(GameLuckyWheelWinnerSaved());
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    // await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return _buildWinnerDialog(_players[playerIndex], playerIndex);
    //   },
    //   useRootNavigator: false,
    // );

    _isPlaying = false;
    setState(() {});
  }
//
// ///Thêm người chơi mới
// void _addPlayer(Player player) {
//   if (!_isPlaying) {
//     assert(player != null);
//     _gameLuckyWheelBloc.add(GameLuckyWheelPlayerInserted(player: player));
//   }
// }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton(
      {Key? key, required this.icon, this.onPressed, this.backgroundColor})
      : super(key: key);
  final Widget icon;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 50,
        width: 50,
        child: Material(
          color: backgroundColor ?? Colors.white.withOpacity(0.13),
          child: IconButton(
            iconSize: 30,
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

///controller điều khiển vòng quay
class _NameController extends ChangeNotifier {
  bool isPlay = false;

  void playAnimation() {
    isPlay = true;
    notifyListeners();
  }
}

class _StartAnimationNameWidget extends StatefulWidget {
  const _StartAnimationNameWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 5000),
    this.angle = 30,
    required this.child,
    this.numberLoop = 6,
    this.nameController,
  }) : super(key: key);

  @override
  __StartAnimationNameWidgetState createState() =>
      __StartAnimationNameWidgetState();
  final Duration duration;
  final Widget child;
  final double angle;
  final int numberLoop;
  final _NameController? nameController;
}

class __StartAnimationNameWidgetState extends State<_StartAnimationNameWidget>
    with SingleTickerProviderStateMixin {
  late _StartAnimationNameController _startController;
  int _countLoop = 0;
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void didUpdateWidget(covariant _StartAnimationNameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    final int milliseconds =
        widget.duration.inMilliseconds ~/ ((widget.numberLoop + 2) * 2);
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: milliseconds));

    _startController = _StartAnimationNameController();
    if (widget.nameController != null) {
      widget.nameController?.addListener(() {
        if (widget.nameController!.isPlay) {
          _countLoop = 0;
          widget.nameController!.isPlay = false;
          _startController.playElementAnimation();
        }
      });
    }

    _startController.addListener(() {
      if (_startController.isElementFinish) {
        if (_countLoop < widget.numberLoop * 2) {
          _startController.playElementAnimation();
        } else {
          _controller.forward();
        }
        _countLoop += 1;
      }
    });

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.nameController == null) {
      _startController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rotation = Tween(begin: -widget.angle, end: 0.0).animate(_rotation);

    final int milliseconds =
        widget.duration.inMilliseconds ~/ ((widget.numberLoop + 2) * 2);

    return Transform.rotate(
      angle: _rotation.value * pi / 180,
      child: _StartElementAnimationNameWidget(
        child: widget.child,
        angle: widget.angle * 2,
        duration: Duration(milliseconds: milliseconds),
        startAnimationNameController: _startController,
      ),
    );
  }
}

///controller điều khiển vòng quay
class _StartAnimationNameController extends ChangeNotifier {
  bool isElementPlay = true;
  bool isElementFinish = false;
  bool isPlay = false;

  void playAnimation() {
    isPlay = true;
    notifyListeners();
  }

  void playElementAnimation() {
    isElementPlay = true;
    isElementFinish = false;
    notifyListeners();
  }

  void finishElementAnimation() {
    isElementFinish = true;
    isElementPlay = false;
    notifyListeners();
  }
}

class _StartElementAnimationNameWidget extends StatefulWidget {
  const _StartElementAnimationNameWidget(
      {Key? key,
      this.duration = const Duration(milliseconds: 5000),
      required this.child,
      this.angle = 30,
      required this.startAnimationNameController})
      : super(key: key);

  @override
  _StartElementAnimationNameWidgetState createState() =>
      _StartElementAnimationNameWidgetState();
  final Duration duration;
  final Widget child;
  final double angle;
  final _StartAnimationNameController startAnimationNameController;
}

class _StartElementAnimationNameWidgetState
    extends State<_StartElementAnimationNameWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    widget.startAnimationNameController.addListener(() {
      if (_controller.value == 1) {
        _controller.reverse();
      } else if (_controller.value == 0) {
        _controller.forward();
      }
    });

    _controller.addListener(() {
      setState(() {});
      if (!_controller.isAnimating &&
          widget.startAnimationNameController.isElementPlay) {
        widget.startAnimationNameController.finishElementAnimation();
      }
    });
    super.initState();
  }

  double angleToRadian(double angle) {
    return (angle * pi) / 180.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rotation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rotation = Tween(begin: 0.0, end: widget.angle).animate(_rotation);

    return Transform.rotate(
      angle: angleToRadian(_rotation.value),
      child: widget.child,
    );
  }
}

class _PlayerItem extends StatelessWidget {
  const _PlayerItem({Key? key, required this.player, required this.height})
      : super(key: key);
  final Player player;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _buildPlayer(player, height);
  }

  ///Giao diện người chơi
  Widget _buildPlayer(Player player, double height) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 7, right: 7),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: CachedNetworkImage(
              height: 86,
              width: 86,
              fit: BoxFit.cover,
              imageBuilder:
                  (BuildContext context, ImageProvider imageProvider) {
                return Container(
                  height: 86,
                  width: 86,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                );
              },
              imageUrl: player.picture ?? '',
              placeholder: (context, url) => Container(
                  height: 86,
                  width: 86,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                  ),
                  child: const SizedBox()),
              errorWidget: (context, url, error) => Container(
                height: 86,
                width: 86,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: Image.asset(
                  "images/no_image.png",
                  height: 86,
                  width: 86,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    player.name ?? '',
                    style:
                        const TextStyle(color: Color(0xff2c333a), fontSize: 19),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/share.svg',
                        color: const Color(0xffCBD1D8),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          player.shareCount.toString(),
                          style: const TextStyle(
                              color: Color(0xff6b7280), fontSize: 17),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SvgPicture.asset('assets/icons/comment.svg',
                          color: const Color(0xffCBD1D8)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          player.commentCount.toString(),
                          style: const TextStyle(
                              color: Color(0xff6b7280), fontSize: 17),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HeroDialogRoute<T> extends PageRoute<T> {
  _HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String? get barrierLabel => null;
}
