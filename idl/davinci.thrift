namespace go davinci
namespace js davinci

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
  6: optional i32 emptyTileCount,
  7: optional i32 boardCardCount, // davinci：公共牌堆剩余卡牌数
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

// Card 达芬奇密码卡牌。color: 0=白 1=黑；num: -1~11。
struct Card {
  1: required string id,       // "1A"
  2: required i32 color,       // 0:白 1:黑
  3: required i32 num,         // 数字，-1~11
  4: required bool isRevealed, // 是否被揭示
  5: required i32 index,       // 牌组中的索引
}

struct PlayerState {
  1: required list<Card> cards,
}

struct LastAction {
  1: required string action,
  2: required string playerID,
  3: optional string payload, // 原始 JSON 字符串
}

struct GameState {
  1: required string currentPlayer,
  2: required string gameStartTime, // RFC3339 时间字符串
  3: required string roomStatus,    // match/waiting/playing/end
  4: required string ownerID,
  5: required i32 maxPlayers,
  6: required map<string, Card> boardCards,
  7: required map<string, PlayerState> players,
  8: optional LastAction lastData,
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
  7: optional i32 finalScore,   // davinci 通常为空
  8: optional i32 finalMoney,   // davinci 通常为空
  9: required i32 finalStocks,  // davinci 通常为 0
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
  11: optional string initialState, // davinci 为空
  12: optional string finalResult,  // davinci 为空
  13: required string createdAt,
  14: required string updatedAt,
  15: optional list<HistoryGamePlayer> players,
}

// HistoryEventMeta davinci 不记录步骤，events 通常为空数组。
struct HistoryEventMeta {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
}

struct HistoryStats {
  1: required i32 totalGames,
  2: required i32 wins,
  3: required double winRate, // 0~1
  4: required double avgScore, // davinci 无分数，通常为 0
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
  3: required list<HistoryEventMeta> events, // davinci 恒为空数组
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

// ---------- 排行榜 ----------

struct LeaderboardEntry {
  1: required i64 userID,
  2: required string playerID,
  3: required i32 totalGames,
  4: optional i32 wins,        // davinci 按胜率排序
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

service DavinciService {
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
