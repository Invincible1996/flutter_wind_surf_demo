class Match {
  final int? id;
  final String date;
  final String time;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final String homeTeamImg;
  final String awayTeamImg;
  final String? createTime;
  final String? updateTime;

  Match({
    this.id,
    required this.date,
    required this.time,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamImg,
    required this.awayTeamImg,
    this.createTime,
    this.updateTime,
  });

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      league: map['league'],
      homeTeam: map['home_team'],
      awayTeam: map['away_team'],
      homeTeamImg: map['home_team_img'],
      awayTeamImg: map['away_team_img'],
      createTime: map['create_time'],
      updateTime: map['update_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'league': league,
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_team_img': homeTeamImg,
      'away_team_img': awayTeamImg,
      'create_time': createTime,
      'update_time': updateTime,
    };
  }
}
