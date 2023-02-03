class StatsModel {
  int? statusCode;
  PlayerStats? playerStats;

  StatsModel({this.statusCode, this.playerStats});

  StatsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    playerStats = json['playerStats'] != null
        ? new PlayerStats.fromJson(json['playerStats'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.playerStats != null) {
      data['playerStats'] = this.playerStats!.toJson();
    }
    return data;
  }
}

class PlayerStats {
  String? teamname;
  String? seasonname;
  String? leaguename;
  String? playername;
  String? bats;
  String? throws;
  String? position;
  int? statID;
  int? teamID;
  int? playerID;
  int? seasonType;
  int? season;
  String? name;
  String? team;
  String? positionfootball;
  String? positionCategory;
  int? globalTeamID;
  List<Pitchingstats>? pitchingstatslist;
  List<Battingstats>? battingstatslist;
  List<States>? states;



  PlayerStats(
      {this.teamname,
        this.seasonname,
        this.leaguename,
        this.playername,
        this.bats,
        this.throws,
        this.position,
        this.pitchingstatslist,
        this.battingstatslist,
        this.statID,
        this.teamID,
        this.playerID,
        this.seasonType,
        this.season,
        this.name,
        this.team,
        this.positionfootball,
        this.positionCategory,
        this.globalTeamID,
        this.states,
      });

  PlayerStats.fromJson(Map<String, dynamic> json) {
    teamname = json['teamname'];
    seasonname = json['seasonname'];
    leaguename = json['leaguename'];
    playername = json['playername'];
    bats = json['bats'];
    throws = json['throws'];
    position = json['position'];
    statID = json['StatID'];
    teamID = json['TeamID'];
    playerID = json['PlayerID'];
    seasonType = json['SeasonType'];
    season = json['Season'];
    name = json['Name'];
    team = json['Team'];
    positionfootball = json['Position'];
    positionCategory = json['PositionCategory'];
    globalTeamID = json['GlobalTeamID'];
    if (json['pitchingstats'] != null && json['pitchingstats'].runtimeType == List) {
      pitchingstatslist = <Pitchingstats>[];
      json['pitchingstats'].forEach((v) {
        print(v);
        pitchingstatslist!.add(new Pitchingstats.fromJson(v));
      });
    } else if (json['pitchingstats'] != null && json['pitchingstats'].runtimeType != List) {
      json['pitchingstats'].forEach((key , value) {
        pitchingstatslist = <Pitchingstats>[];
        pitchingstatslist!.add(new Pitchingstats.fromJson(json['pitchingstats']));
      });
    }

    if (json['battingstats'] != null && json['battingstats'].runtimeType == List) {
      battingstatslist = <Battingstats>[];
      json['battingstats'].forEach((v) {
        battingstatslist!.add(new Battingstats.fromJson(v));
      });
    } else if (json['battingstats'] != null && json['battingstats'].runtimeType != List) {
      json['battingstats'].forEach((key , value) {
        battingstatslist = <Battingstats>[];
        battingstatslist?.add(Battingstats.fromJson(json['battingstats']));
      });
    }
    if (json['states'] != null && json['states'].runtimeType == List) {
      states = <States>[];
      json['states'].forEach((v) {
        print(v);
        states!.add(new States.fromJson(v));
      });
    } else if (json['states'] != null && json['states'].runtimeType != List) {
      json['states'].forEach((key , value) {
        states = <States>[];
        states!.add(new States.fromJson(json['states']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamname'] = this.teamname;
    data['seasonname'] = this.seasonname;
    data['leaguename'] = this.leaguename;
    data['playername'] = this.playername;
    data['bats'] = this.bats;
    data['throws'] = this.throws;
    data['position'] = this.position;
    data['StatID'] = this.statID;
    data['TeamID'] = this.teamID;
    data['PlayerID'] = this.playerID;
    data['SeasonType'] = this.seasonType;
    data['Season'] = this.season;
    data['Name'] = this.name;
    data['Team'] = this.team;
    data['Position'] = this.positionfootball;
    data['PositionCategory'] = this.positionCategory;
    data['GlobalTeamID'] = this.globalTeamID;
    if (this.pitchingstatslist != null) {
      data['battingstats'] = this.pitchingstatslist!.map((v) => v.toJson()).toList();
    }
    if (this.battingstatslist != null) {
      data['battingstats'] = this.battingstatslist!.map((v) => v.toJson()).toList();
    }
    if (this.states != null) {
      data['states'] = this.states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pitchingstats {
  String? name;
  String? gp;
  String? w;
  String? l;
  String? h;
  String? bb;
  String? er;
  String? gs;
  String? era;
  String? sho;
  String? sv;
  String? ip;
  String? so;

  Pitchingstats(
      {this.name,
        this.gp,
        this.w,
        this.l,
        this.h,
        this.bb,
        this.er,
        this.gs,
        this.era,
        this.sho,
        this.sv,
        this.ip,
        this.so});

  Pitchingstats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gp = json['gp'];
    w = json['w'];
    l = json['l'];
    h = json['h'];
    bb = json['bb'];
    er = json['er'];
    gs = json['gs'];
    era = json['era'];
    sho = json['sho'];
    sv = json['sv'];
    ip = json['ip'];
    so = json['so'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gp'] = this.gp;
    data['w'] = this.w;
    data['l'] = this.l;
    data['h'] = this.h;
    data['bb'] = this.bb;
    data['er'] = this.er;
    data['gs'] = this.gs;
    data['era'] = this.era;
    data['sho'] = this.sho;
    data['sv'] = this.sv;
    data['ip'] = this.ip;
    data['so'] = this.so;
    return data;
  }
}

class Battingstats {
  String? name;
  String? gp;
  String? ab;
  String? r;
  String? h;
  String? bb;
  String? x2b;
  String? x3b;
  String? bib;
  String? trib;
  String? hr;
  String? rbi;
  String? avg;
  String? so;
  String? sb;

  Battingstats(
      {this.name,
        this.gp,
        this.ab,
        this.r,
        this.h,
        this.bb,
        this.x2b,
        this.x3b,
        this.bib,
        this.trib,
        this.hr,
        this.rbi,
        this.avg,
        this.so,
        this.sb});

  Battingstats.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gp = json['gp'];
    ab = json['ab'];
    r = json['r'];
    h = json['h'];
    bb = json['bb'];
    x2b = json['x_2b'];
    x3b = json['x_3b'];
    bib = json['bib'];
    trib = json['trib'];
    hr = json['hr'];
    rbi = json['rbi'];
    avg = json['avg'];
    so = json['so'];
    sb = json['sb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gp'] = this.gp;
    data['ab'] = this.ab;
    data['r'] = this.r;
    data['h'] = this.h;
    data['bb'] = this.bb;
    data['x_2b'] = this.x2b;
    data['x_3b'] = this.x3b;
    data['bib'] = this.bib;
    data['trib'] = this.trib;
    data['hr'] = this.hr;
    data['rbi'] = this.rbi;
    data['avg'] = this.avg;
    data['so'] = this.so;
    data['sb'] = this.sb;
    return data;
  }
}

class States {
  String? updated;
  String? created;
  dynamic games;
  dynamic fantasyPoints;
  dynamic passingAttempts;
  dynamic passingCompletions;
  dynamic passingYards;
  dynamic passingCompletionPercentage;
  dynamic passingYardsPerAttempt;
  dynamic passingYardsPerCompletion;
  dynamic passingTouchdowns;
  dynamic passingInterceptions;
  dynamic passingRating;
  dynamic rushingAttempts;
  dynamic rushingYards;
  dynamic rushingYardsPerAttempt;
  dynamic rushingTouchdowns;
  dynamic rushingLong;
  dynamic receptions;
  dynamic receivingYards;
  dynamic receivingYardsPerReception;
  dynamic receivingTouchdowns;
  dynamic receivingLong;
  dynamic puntReturns;
  dynamic puntReturnYards;
  dynamic puntReturnYardsPerAttempt;
  dynamic puntReturnTouchdowns;
  dynamic puntReturnLong;
  dynamic kickReturns;
  dynamic kickReturnYards;
  dynamic kickReturnYardsPerAttempt;
  dynamic kickReturnTouchdowns;
  dynamic kickReturnLong;
  dynamic punts;
  dynamic puntYards;
  dynamic puntAverage;
  dynamic puntLong;
  dynamic fieldGoalsAttempted;
  dynamic fieldGoalsMade;
  dynamic fieldGoalPercentage;
  dynamic fieldGoalsLongestMade;
  dynamic extraPointsAttempted;
  dynamic extraPointsMade;
  dynamic interceptions;
  dynamic interceptionReturnYards;
  dynamic interceptionReturnTouchdowns;
  dynamic soloTackles;
  dynamic assistedTackles;
  dynamic tacklesForLoss;
  dynamic sacks;
  dynamic passesDefended;
  dynamic fumblesRecovered;
  dynamic fumbleReturnTouchdowns;
  dynamic quarterbackHurries;
  dynamic fumbles;
  dynamic fumblesLost;

  States(
      {this.updated,
        this.created,
        this.games,
        this.fantasyPoints,
        this.passingAttempts,
        this.passingCompletions,
        this.passingYards,
        this.passingCompletionPercentage,
        this.passingYardsPerAttempt,
        this.passingYardsPerCompletion,
        this.passingTouchdowns,
        this.passingInterceptions,
        this.passingRating,
        this.rushingAttempts,
        this.rushingYards,
        this.rushingYardsPerAttempt,
        this.rushingTouchdowns,
        this.rushingLong,
        this.receptions,
        this.receivingYards,
        this.receivingYardsPerReception,
        this.receivingTouchdowns,
        this.receivingLong,
        this.puntReturns,
        this.puntReturnYards,
        this.puntReturnYardsPerAttempt,
        this.puntReturnTouchdowns,
        this.puntReturnLong,
        this.kickReturns,
        this.kickReturnYards,
        this.kickReturnYardsPerAttempt,
        this.kickReturnTouchdowns,
        this.kickReturnLong,
        this.punts,
        this.puntYards,
        this.puntAverage,
        this.puntLong,
        this.fieldGoalsAttempted,
        this.fieldGoalsMade,
        this.fieldGoalPercentage,
        this.fieldGoalsLongestMade,
        this.extraPointsAttempted,
        this.extraPointsMade,
        this.interceptions,
        this.interceptionReturnYards,
        this.interceptionReturnTouchdowns,
        this.soloTackles,
        this.assistedTackles,
        this.tacklesForLoss,
        this.sacks,
        this.passesDefended,
        this.fumblesRecovered,
        this.fumbleReturnTouchdowns,
        this.quarterbackHurries,
        this.fumbles,
        this.fumblesLost});

  States.fromJson(Map<String, dynamic> json) {
    updated = json['Updated'];
    created = json['Created'];
    games = json['Games'];
    fantasyPoints = json['FantasyPoints'];
    passingAttempts = json['PassingAttempts'];
    passingCompletions = json['PassingCompletions'];
    passingYards = json['PassingYards'];
    passingCompletionPercentage = json['PassingCompletionPercentage'];
    passingYardsPerAttempt = json['PassingYardsPerAttempt'];
    passingYardsPerCompletion = json['PassingYardsPerCompletion'];
    passingTouchdowns = json['PassingTouchdowns'];
    passingInterceptions = json['PassingInterceptions'];
    passingRating = json['PassingRating'];
    rushingAttempts = json['RushingAttempts'];
    rushingYards = json['RushingYards'];
    rushingYardsPerAttempt = json['RushingYardsPerAttempt'];
    rushingTouchdowns = json['RushingTouchdowns'];
    rushingLong = json['RushingLong'];
    receptions = json['Receptions'];
    receivingYards = json['ReceivingYards'];
    receivingYardsPerReception = json['ReceivingYardsPerReception'];
    receivingTouchdowns = json['ReceivingTouchdowns'];
    receivingLong = json['ReceivingLong'];
    puntReturns = json['PuntReturns'];
    puntReturnYards = json['PuntReturnYards'];
    puntReturnYardsPerAttempt = json['PuntReturnYardsPerAttempt'];
    puntReturnTouchdowns = json['PuntReturnTouchdowns'];
    puntReturnLong = json['PuntReturnLong'];
    kickReturns = json['KickReturns'];
    kickReturnYards = json['KickReturnYards'];
    kickReturnYardsPerAttempt = json['KickReturnYardsPerAttempt'];
    kickReturnTouchdowns = json['KickReturnTouchdowns'];
    kickReturnLong = json['KickReturnLong'];
    punts = json['Punts'];
    puntYards = json['PuntYards'];
    puntAverage = json['PuntAverage'];
    puntLong = json['PuntLong'];
    fieldGoalsAttempted = json['FieldGoalsAttempted'];
    fieldGoalsMade = json['FieldGoalsMade'];
    fieldGoalPercentage = json['FieldGoalPercentage'];
    fieldGoalsLongestMade = json['FieldGoalsLongestMade'];
    extraPointsAttempted = json['ExtraPointsAttempted'];
    extraPointsMade = json['ExtraPointsMade'];
    interceptions = json['Interceptions'];
    interceptionReturnYards = json['InterceptionReturnYards'];
    interceptionReturnTouchdowns = json['InterceptionReturnTouchdowns'];
    soloTackles = json['SoloTackles'];
    assistedTackles = json['AssistedTackles'];
    tacklesForLoss = json['TacklesForLoss'];
    sacks = json['Sacks'];
    passesDefended = json['PassesDefended'];
    fumblesRecovered = json['FumblesRecovered'];
    fumbleReturnTouchdowns = json['FumbleReturnTouchdowns'];
    quarterbackHurries = json['QuarterbackHurries'];
    fumbles = json['Fumbles'];
    fumblesLost = json['FumblesLost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Updated'] = this.updated;
    data['Created'] = this.created;
    data['Games'] = this.games;
    data['FantasyPoints'] = this.fantasyPoints;
    data['PassingAttempts'] = this.passingAttempts;
    data['PassingCompletions'] = this.passingCompletions;
    data['PassingYards'] = this.passingYards;
    data['PassingCompletionPercentage'] = this.passingCompletionPercentage;
    data['PassingYardsPerAttempt'] = this.passingYardsPerAttempt;
    data['PassingYardsPerCompletion'] = this.passingYardsPerCompletion;
    data['PassingTouchdowns'] = this.passingTouchdowns;
    data['PassingInterceptions'] = this.passingInterceptions;
    data['PassingRating'] = this.passingRating;
    data['RushingAttempts'] = this.rushingAttempts;
    data['RushingYards'] = this.rushingYards;
    data['RushingYardsPerAttempt'] = this.rushingYardsPerAttempt;
    data['RushingTouchdowns'] = this.rushingTouchdowns;
    data['RushingLong'] = this.rushingLong;
    data['Receptions'] = this.receptions;
    data['ReceivingYards'] = this.receivingYards;
    data['ReceivingYardsPerReception'] = this.receivingYardsPerReception;
    data['ReceivingTouchdowns'] = this.receivingTouchdowns;
    data['ReceivingLong'] = this.receivingLong;
    data['PuntReturns'] = this.puntReturns;
    data['PuntReturnYards'] = this.puntReturnYards;
    data['PuntReturnYardsPerAttempt'] = this.puntReturnYardsPerAttempt;
    data['PuntReturnTouchdowns'] = this.puntReturnTouchdowns;
    data['PuntReturnLong'] = this.puntReturnLong;
    data['KickReturns'] = this.kickReturns;
    data['KickReturnYards'] = this.kickReturnYards;
    data['KickReturnYardsPerAttempt'] = this.kickReturnYardsPerAttempt;
    data['KickReturnTouchdowns'] = this.kickReturnTouchdowns;
    data['KickReturnLong'] = this.kickReturnLong;
    data['Punts'] = this.punts;
    data['PuntYards'] = this.puntYards;
    data['PuntAverage'] = this.puntAverage;
    data['PuntLong'] = this.puntLong;
    data['FieldGoalsAttempted'] = this.fieldGoalsAttempted;
    data['FieldGoalsMade'] = this.fieldGoalsMade;
    data['FieldGoalPercentage'] = this.fieldGoalPercentage;
    data['FieldGoalsLongestMade'] = this.fieldGoalsLongestMade;
    data['ExtraPointsAttempted'] = this.extraPointsAttempted;
    data['ExtraPointsMade'] = this.extraPointsMade;
    data['Interceptions'] = this.interceptions;
    data['InterceptionReturnYards'] = this.interceptionReturnYards;
    data['InterceptionReturnTouchdowns'] = this.interceptionReturnTouchdowns;
    data['SoloTackles'] = this.soloTackles;
    data['AssistedTackles'] = this.assistedTackles;
    data['TacklesForLoss'] = this.tacklesForLoss;
    data['Sacks'] = this.sacks;
    data['PassesDefended'] = this.passesDefended;
    data['FumblesRecovered'] = this.fumblesRecovered;
    data['FumbleReturnTouchdowns'] = this.fumbleReturnTouchdowns;
    data['QuarterbackHurries'] = this.quarterbackHurries;
    data['Fumbles'] = this.fumbles;
    data['FumblesLost'] = this.fumblesLost;
    return data;
  }
}

