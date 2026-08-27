namespace go pam.games.common.v1
namespace js pam.games.common.v1

// 历史对局公共契约。仅放置所有游戏语义与字段编号一致的结构。

struct HistoryGamePlayer {
  1: required i64 id,
  2: required i64 gameID,
  3: optional i64 userID,       // AI 为空
  4: required string playerID,
  5: required i32 seatIndex,
  6: required bool isAI,
  7: optional i32 finalScore,
  8: optional i32 finalMoney,
  9: required i32 finalStocks,
  10: optional i32 finalRank,
  11: required bool isWinner,
  12: required string createdAt,
}

struct HistoryGame {
  1: required i64 id,
  2: required string roomID,
  3: required string gameType,
  4: required string startedAt,
  5: optional string endedAt,
  6: required i32 durationSeconds,
  7: optional i64 winnerUserID,
  8: optional string winnerPlayerID,
  9: optional string endReason,
  10: required i32 maxPlayers,
  11: optional string initialState, // 回放用 JSON
  12: optional string finalResult,  // 终局结果 JSON
  13: required string createdAt,
  14: required string updatedAt,
  15: optional list<HistoryGamePlayer> players,
}

struct HistoryEventMeta {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
}

struct HistoryStats {
  1: required i32 totalGames,
  2: required i32 wins,
  3: required double winRate, // 0~1
  4: required double avgScore,
}

struct ListHistoryGamesReq {
  1: optional string game_type (api.query = "game_type"),
  2: optional i32 limit (api.query = "limit"),
  3: optional i32 offset (api.query = "offset"),
}

struct HistoryListData {
  1: required list<HistoryGame> games,
}

struct HistoryListResp {
  1: required i32 status_code,
  2: required string message,
  3: required HistoryListData data,
}

struct HistoryDetailReq {
  1: required i64 id (api.path = "id"),
  2: optional string game_type (api.query = "game_type"),
}

struct HistoryDetailData {
  1: required HistoryGame game,
  2: required list<HistoryGamePlayer> players,
  3: required list<HistoryEventMeta> events,
}

struct HistoryDetailResp {
  1: required i32 status_code,
  2: required string message,
  3: required HistoryDetailData data,
}

struct HistoryStatsReq {
  1: optional string game_type (api.query = "game_type"),
}

struct HistoryStatsResp {
  1: required i32 status_code,
  2: required string message,
  3: required HistoryStats data,
}
