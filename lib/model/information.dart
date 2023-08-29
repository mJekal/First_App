class Information {
  String? goal;
  String? promise;
  String? dDay;

  Information({this.goal, this.promise, this.dDay});


  Map<String, dynamic> toMap() {
    return {
      'goal': goal,
      'promise': promise,
      'dDay': dDay,
    };
  }

  static Information fromMap(Map<String, dynamic> map) {
    return Information(
      goal: map['goal'],
      promise: map['promise'],
      dDay: map['dDay'],
    );
  }
}