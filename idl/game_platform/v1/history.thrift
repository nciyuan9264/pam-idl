namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "types.thrift"
include "acquire.thrift"
include "splendor.thrift"
include "yinsh.thrift"
include "othello.thrift"

struct HistoryGamePlayer {
  1: required i64 id (api.js_conv = "true"),
  2: required i64 gameID (api.js_conv = "true"),
  3: optional i64 userID (api.js_conv = "true"),
  4: required string playerID,
  5: required i32 seatIndex,
  6: required bool isAI,
  7: optional i32 finalScore,
  8: optional i32 finalMoney,
  9: required i32 finalStocks,
  10: optional i32 finalRank,
  11: required bool isWinner,
  12: required types.ISODateTime createdAt,
  13: optional string displayName,
  14: optional string gameRole,
}

struct HistoryGame {
  1: required i64 id (api.js_conv = "true"),
  2: required string roomID,
  3: required types.GameType gameType,
  4: required types.ISODateTime startedAt,
  5: optional types.ISODateTime endedAt,
  6: required i32 durationSeconds,
  7: optional i64 winnerUserID (api.js_conv = "true"),
  8: optional string winnerPlayerID,
  9: optional string endReason,
  10: required i32 maxPlayers,
  11: required types.ISODateTime createdAt,
  12: required types.ISODateTime updatedAt,
  13: optional list<HistoryGamePlayer> players,
  14: optional string roomDisplayName,
}

struct HistoryEventMeta {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
  4: optional string displayName,
}

struct HistoryStats {
  1: required i32 totalGames,
  2: required i32 wins,
  3: required double winRate,
  4: required double avgScore,
  5: optional map<string, i32> gamesByRole,
  6: optional map<string, i32> winsByRole,
}

struct DavinciLeaderboardMetric {
  1: required i32 wins,
  2: required double winRate,
}

struct RankLeaderboardMetric {
  1: required double avgRank,
}

struct YinshLeaderboardMetric {
  1: required i32 wins,
  2: required double winRate,
}

struct OthelloLeaderboardMetric {
  1: required i32 wins,
  2: required double winRate,
}

struct FugitiveLeaderboardMetric {
  1: required i32 wins,
  2: required double winRate,
}

union LeaderboardMetric {
  1: DavinciLeaderboardMetric davinci,
  2: RankLeaderboardMetric rank,
  3: YinshLeaderboardMetric yinsh,
  4: OthelloLeaderboardMetric othello,
  5: FugitiveLeaderboardMetric fugitive,
}

struct LeaderboardEntry {
  1: required i64 userID (api.js_conv = "true"),
  2: required string playerID,
  3: required i32 totalGames,
  4: required LeaderboardMetric metric,
  5: optional string displayName,
}

union ReplaySnapshot {
  1: acquire.AcquireReplaySnapshot acquire,
  2: splendor.SplendorReplaySnapshot splendor,
  3: yinsh.YinshReplaySnapshot yinsh,
  4: othello.OthelloReplaySnapshot othello,
}

struct ListHistoryGamesReq {
  1: required types.GameType game_type (api.query = "gameType"),
  2: optional i32 limit (api.query = "limit"),
  3: optional i32 offset (api.query = "offset"),
}

struct GetHistoryDetailReq {
  1: required i64 id (api.path = "id", api.js_conv = "true"),
  2: required types.GameType game_type (api.query = "gameType"),
}

struct GetSnapshotReq {
  1: required i64 id (api.path = "id", api.js_conv = "true"),
  2: required types.GameType game_type (api.query = "gameType"),
  3: required i32 seq (api.query = "seq"),
}

struct ListSnapshotsReq {
  1: required i64 id (api.path = "id", api.js_conv = "true"),
  2: required types.GameType game_type (api.query = "gameType"),
  3: optional i32 limit (api.query = "limit"),
  4: optional i32 offset (api.query = "offset"),
}

struct GetStatsReq {
  1: required types.GameType game_type (api.query = "gameType"),
}

struct GetLeaderboardReq {
  1: required types.GameType game_type (api.query = "gameType"),
  2: optional string sort (api.query = "sort"),
  3: optional i32 limit (api.query = "limit"),
  4: optional i32 offset (api.query = "offset"),
  5: optional string game_role (api.query = "gameRole"),
}

struct HistoryListData {
  1: required list<HistoryGame> games,
  2: required types.PageInfo page,
}

struct HistoryListResp {
  1: required i32 status_code,
  2: required string message,
  3: required HistoryListData data,
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

struct SnapshotResp {
  1: required i32 status_code,
  2: required string message,
  3: required ReplaySnapshot data,
}

struct SnapshotListData {
  1: required list<ReplaySnapshot> snapshots,
  2: required i32 totalEvents,
  3: required i32 totalSnapshots,
  4: required types.PageInfo page,
}

struct SnapshotListResp {
  1: required i32 status_code,
  2: required string message,
  3: required SnapshotListData data,
}

struct StatsResp {
  1: required i32 status_code,
  2: required string message,
  3: required HistoryStats data,
}

struct LeaderboardData {
  1: required types.GameType gameType,
  2: required list<LeaderboardEntry> entries,
  3: required types.PageInfo page,
}

struct LeaderboardResp {
  1: required i32 status_code,
  2: required string message,
  3: required LeaderboardData data,
}
