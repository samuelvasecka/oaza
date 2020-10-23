class Profile {
  static Profile _self = null;
  static getInstance() {
    if (_self == null) {
      _self = Profile();
    }
    return _self;
  }

  String fullName;
  String groupId;
  String email;
  Map stepsStart;
  List roles;
  bool loggedIn;
  String password;
  Map actualStepDay;

  void setName(String fullName) {
    this.fullName = fullName;
  }

  void setGroupId(String groupId) {
    this.groupId = groupId;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setRoles(List roles) {
    this.roles = roles;
  }

  void setStepsStart(Map stepsStart) {
    this.stepsStart = stepsStart;
  }

  void setLoggedIn(bool loggedIn) {
    this.loggedIn = loggedIn;
  }

  void setActualStepDay(Map actualStepDay) {
    this.actualStepDay = actualStepDay;
  }

  Map toJson() {
    return {
      "full_name": this.fullName,
      "group_id": this.groupId,
      "email": this.email,
      "roles": this.roles,
      "steps_start": this.stepsStart,
      "logged_in": this.loggedIn,
      "password": this.password,
      "actual_step_day": this.actualStepDay,
    };
  }
}
