class LuckyWheelSetting {
  LuckyWheelSetting({
    this.hasOrder = false,
    this.isPriorityComment = false,
    this.isPriorityShare = false,
    this.isIgnorePriorityWinner = false,
    this.isPriorityShareGroup = false,
    this.isPrioritySharePersonal = false,
    this.isSkipWinner = false,
    this.numberSkipDays = 7,
    this.timeInSecond = 5,
    this.isPriority = true,
    this.useShareApi = false,
    this.minNumberComment = 0,
    this.minNumberShare = 0,
    this.minNumberShareGroup = 0,
    this.isPriorityUnWinner = false,
    this.isMinComment = false,
    this.isMinShare = false,
    this.isMinShareGroup = false,
    this.numberBonusPriority = 2,
    this.saveWhenFinished = false,
  });

  LuckyWheelSetting.fromJson(Map<String, dynamic> data) {
    hasOrder = data['hasOrder'];
    isSkipWinner = data['isSkipWinner'];
    isPriority = data['isPriority'];
    isPriorityShare = data['isPriorityShare'];
    isPriorityShareGroup = data['isPriorityShareGroup'];
    isPrioritySharePersonal = data['isPrioritySharePersonal'];
    isPriorityComment = data['isPriorityComment'];
    isIgnorePriorityWinner = data['isIgnorePriorityWinner'];
    numberSkipDays = data['numberSkipDays'];
    timeInSecond = data['timeInSecond'];
    minNumberComment = data['minNumberComment'];
    minNumberShare = data['minNumberShare'];
    minNumberShareGroup = data['minNumberShareGroup'];
    useShareApi = data['useShareApi'];
    isPriorityUnWinner = data['isPriorityUnWinner'];
    isMinShare = data['isMinShare'];
    isMinShareGroup = data['isMinShareGroup'];
    isMinComment = data['isMinComment'];
    saveWhenFinished = data['saveWhenFinished'];
  }

  LuckyWheelSetting copyWith({
    bool? hasOrder,
    bool? isIgnorePriorityWinner,
    bool? isMinComment,
    bool? isMinShare,
    bool? isMinShareGroup,
    bool? isPriority,
    bool? isPriorityComment,
    bool? isPriorityShare,
    bool? isPriorityShareGroup,
    bool? isPrioritySharePersonal,
    bool? isPriorityUnWinner,
    bool? isSkipWinner,
    bool? useShareApi,
    bool? saveWhenFinished,
    int? minNumberComment,
    int? minNumberShare,
    int? minNumberShareGroup,
    int? numberBonusPriority,
    int? numberSkipDays,
    int? timeInSecond,
  }) {
    return LuckyWheelSetting(
      hasOrder: hasOrder ?? this.hasOrder,
      isIgnorePriorityWinner:
          isIgnorePriorityWinner ?? this.isIgnorePriorityWinner,
      isMinComment: isMinComment ?? this.isMinComment,
      isMinShare: isMinShare ?? this.isMinShare,
      isMinShareGroup: isMinShareGroup ?? this.isMinShareGroup,
      isPriority: isPriority ?? this.isPriority,
      isPriorityComment: isPriorityComment ?? this.isPriorityComment,
      isPriorityShare: isPriorityShare ?? this.isPriorityShare,
      isPriorityShareGroup: isPriorityShareGroup ?? this.isPriorityShareGroup,
      isPrioritySharePersonal:
          isPrioritySharePersonal ?? this.isPrioritySharePersonal,
      isPriorityUnWinner: isPriorityUnWinner ?? this.isPriorityUnWinner,
      isSkipWinner: isSkipWinner ?? this.isSkipWinner,
      useShareApi: useShareApi ?? this.useShareApi,
      minNumberComment: minNumberComment ?? this.minNumberComment,
      minNumberShare: minNumberShare ?? this.minNumberShare,
      minNumberShareGroup: minNumberShareGroup ?? this.minNumberShareGroup,
      numberBonusPriority: numberBonusPriority ?? this.numberBonusPriority,
      numberSkipDays: numberSkipDays ?? this.numberSkipDays,
      timeInSecond: timeInSecond ?? this.timeInSecond,
      saveWhenFinished: saveWhenFinished ?? this.saveWhenFinished,
    );
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasOrder'] = hasOrder;
    data['isSkipWinner'] = isSkipWinner;
    data['isPriority'] = isPriority;
    data['isPriorityShare'] = isPriorityShare;
    data['isPriorityShareGroup'] = isPriorityShareGroup;
    data['isPrioritySharePersonal'] = isPrioritySharePersonal;
    data['isPriorityComment'] = isPriorityComment;
    data['isIgnorePriorityWinner'] = isIgnorePriorityWinner;
    data['numberSkipDays'] = numberSkipDays;
    data['timeInSecond'] = timeInSecond;
    data['minNumberComment'] = minNumberComment;
    data['minNumberShare'] = minNumberShare;
    data['minNumberShareGroup'] = minNumberShareGroup;
    data['useShareApi'] = useShareApi;
    data['isPriorityUnWinner'] = isPriorityUnWinner;
    data['isMinShare'] = isMinShare;
    data['isMinShareGroup'] = isMinShareGroup;
    data['isMinComment'] = isMinComment;
    data['saveWhenFinished'] = saveWhenFinished;

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }

  ///Đối tượng tham gia có đơn hàng
  late bool hasOrder;

  ///Bỏ qua người chơi thắng cuộc
  late bool isSkipWinner;

  ///Dùng các tham số ưu tiên
  late bool isPriority;

  ///Ưu tiên người có lượt chia sẽ nhiều hơn
  late bool isPriorityShare;

  ///Ưu tiên người có chia sẽ nhóm nhiều hơn
  late bool isPriorityShareGroup;

  ///Ưu tiên người sẽ các nhân
  late bool isPrioritySharePersonal;

  ///Ưu tiên người comment nhiều
  late bool isPriorityComment;

  ///Bỏ qua người chơi thắng cuộc
  late bool isIgnorePriorityWinner;

  ///Số ngày người thắng cuộc được tiếp tục tham gia kể từ khi thắng
  late int numberSkipDays;

  ///Thời gian vòng quay
  late int timeInSecond;

  ///Số comment tối thiểu
  late int minNumberComment;

  ///Số lượt chia sẻ tối thiểu
  late int minNumberShare;

  ///Số lượt chia sẻ nhóm tối thiểu
  late int minNumberShareGroup;

  ///Số lượng nhân với giá trị của các trường ưu tiên
  late int numberBonusPriority;

  ///Dùng người chơi từ chia sẻ hay comment
  late bool useShareApi;

  ///Ưu tiên người chơi không thắng cuộc
  late bool isPriorityUnWinner;

  ///Chia sẻ ít nhất dựa vào [minNumberShare]
  late bool isMinShare;

  ///Chia sẻ nhóm ít nhất dựa vào [minNumberShareGroup]
  late bool isMinShareGroup;

  ///Comment ít nhất dựa vào [minNumberComment]
  late bool isMinComment;

  ///Lưu lại người thắng cuộc sau khi quay
  late bool saveWhenFinished;
}
