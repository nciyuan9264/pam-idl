namespace go pam.games.common.v1
namespace js pam.games.common.v1

// 排行榜公共契约。仅放置所有游戏语义与字段编号一致的结构。

struct LeaderboardEntry {
  1: required i64 userID,
  2: required string playerID,
  3: required i32 totalGames,
  4: optional i32 wins,
  5: optional double winRate,
  6: optional double avgRank,
}

struct LeaderboardReq {
  1: optional string game_type (api.query = "game_type"),
  2: optional i32 limit (api.query = "limit"),
  3: optional i32 offset (api.query = "offset"),
}

struct LeaderboardData {
  1: required string gameType,
  2: required list<LeaderboardEntry> entries,
}

struct LeaderboardResp {
  1: required i32 status_code,
  2: required string message,
  3: required LeaderboardData data,
}
