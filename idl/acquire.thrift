namespace go acquire
namespace js acquire

// ---------- 通用响应 ----------

struct BaseResp {
  1: required i32 status_code,
  2: required string message,
}

// ---------- 房间列表 ----------

struct RoomPlayer {
  1: required string playerID,
  2: required bool online,
  3: required bool ai,
  4: required bool ready,
}

// RoomInfo 是 /room/list 的统一房间外壳，游戏专属字段用 optional 承载。
struct RoomInfo {
  1: required string roomID,
  2: required string status,
  3: required string ownerID,
  4: required list<RoomPlayer> roomPlayer,
  5: optional i32 maxPlayers,
  6: optional i32 emptyTileCount, // acquire：棋盘剩余空格子数
  7: optional i32 boardCardCount,
  8: optional i32 maxScore,
}

struct CreateRoomData {
  1: required string roomID,
}

struct CreateRoomResp {
  1: required i32 status_code,
  2: required string message,
  3: required CreateRoomData data,
}

struct RoomListData {
  1: required list<RoomInfo> rooms,
}

struct RoomListResp {
  1: required i32 status_code,
  2: required string message,
  3: required RoomListData data,
}

// ---------- 游戏状态（game_status）----------

struct Tile {
  1: required string id,     // "1A"
  2: required string belong, // 公司名
}

struct PlayerState {
  1: required i32 money,
  2: required map<string, i32> stocks,
  3: required list<string> tiles,
}

struct CompanyState {
  1: required string name,
  2: required i32 tiles,
  3: required i32 stockTotal,
  4: required i32 stockPrice,
}

struct MergingSelection {
  1: required list<string> mainCompany,
  2: required list<string> otherCompany,
}

struct SettleData {
  1: required list<string> hoders,
  2: required map<string, i32> dividends,
}

struct GameState {
  1: required string currentPlayer,
  2: required string gameStartTime, // RFC3339 时间字符串
  3: required string lastTileKey,
  4: required string roomStatus,    // match/waiting/playing/merging/mergingSelection/mergingSettle/end
  5: required string ownerID,
  6: required i32 maxPlayers,
  7: required map<string, Tile> boardTiles,
  8: required map<string, PlayerState> players,
  9: required map<string, CompanyState> companies,
  10: required string mergeMainCompany,
  11: required MergingSelection mergingSelection,
  12: required map<string, SettleData> mergeSettleData,
}

struct RoomPlayerConn {
  1: required string playerID,
  2: required bool online,
  3: required bool ready,
  4: required bool ai,
}

struct Room {
  1: required string roomID,
  2: required map<string, RoomPlayerConn> connections,
  3: required list<string> playerSeq,
  4: required GameState state,
}

// RoomService 是 game_status 返回的运行时房间服务对象（JSON 键为首字母大写）。
struct RoomService {
  1: required Room Room,
  2: required i32 HistorySeq,
  3: required string HistoryStartedAt,
  4: required bool HistoryEnded,
}

struct GameStatusReq {
  1: required string room_id (api.query = "room_id"),
}

struct GameStatusResp {
  1: required i32 status_code,
  2: required string message,
  3: required RoomService data,
}

// ---------- 历史对局 ----------

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

// ---------- 回放快照 ----------

struct EventInfo {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
  4: optional string payload, // 原始 JSON
}

// Snapshot 单步快照；roomData/playersData/result 为动态 JSON 对象字符串。
struct Snapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional EventInfo currentEvent,
  4: required string roomData,
  5: required string playersData,
  6: required string result,
}

struct SnapshotReq {
  1: required i64 id (api.path = "id"),
  2: optional string game_type (api.query = "game_type"),
  3: optional i32 seq (api.query = "seq"), // 回放到第几步，-1 表示初始状态
}

struct SnapshotResp {
  1: required i32 status_code,
  2: required string message,
  3: required Snapshot data,
}

struct SnapshotsReq {
  1: required i64 id (api.path = "id"),
}

struct SnapshotsData {
  1: required i32 totalEvents,
  2: required list<Snapshot> snapshots,
}

struct SnapshotsResp {
  1: required i32 status_code,
  2: required string message,
  3: required SnapshotsData data,
}

// ---------- 排行榜 ----------

struct LeaderboardEntry {
  1: required i64 userID,
  2: required string playerID,
  3: required i32 totalGames,
  4: optional i32 wins,
  5: optional double winRate,
  6: optional double avgRank, // acquire 按平均名次排序
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

service AcquireService {
  CreateRoomResp CreateRoom() (
    api.post = "/room/create",
    api.operation_id = "createRoom",
    api.summary = "创建房间",
    api.auth_required = "true"
  )

  RoomListResp GetRoomList() (
    api.get = "/room/list",
    api.operation_id = "getRoomList",
    api.summary = "获取房间列表",
    api.auth_required = "true"
  )

  GameStatusResp GetGameStatus(1: GameStatusReq req) (
    api.get = "/room/game_status",
    api.operation_id = "getGameStatus",
    api.summary = "获取房间游戏状态",
    api.auth_required = "true"
  )

  HistoryListResp ListHistoryGames(1: ListHistoryGamesReq req) (
    api.get = "/history/games",
    api.operation_id = "listHistoryGames",
    api.summary = "查询当前用户历史对局列表",
    api.auth_required = "true"
  )

  HistoryDetailResp GetHistoryGameDetail(1: HistoryDetailReq req) (
    api.get = "/history/game/:id",
    api.operation_id = "getHistoryGameDetail",
    api.summary = "查询单局历史详情",
    api.auth_required = "true"
  )

  SnapshotResp GetHistoryGameSnapshot(1: SnapshotReq req) (
    api.get = "/history/game/:id/snapshot",
    api.operation_id = "getHistoryGameSnapshot",
    api.summary = "查询单步回放快照",
    api.auth_required = "true"
  )

  SnapshotsResp GetHistoryGameSnapshots(1: SnapshotsReq req) (
    api.get = "/history/game/:id/snapshots",
    api.operation_id = "getHistoryGameSnapshots",
    api.summary = "查询整局所有回合快照",
    api.auth_required = "true"
  )

  HistoryStatsResp GetHistoryStats(1: HistoryStatsReq req) (
    api.get = "/history/stats",
    api.operation_id = "getHistoryStats",
    api.summary = "查询当前用户胜率统计",
    api.auth_required = "true"
  )

  LeaderboardResp GetLeaderboard(1: LeaderboardReq req) (
    api.get = "/ranking/leaderboard",
    api.operation_id = "getLeaderboard",
    api.summary = "查询全玩家排行榜"
  )
}
