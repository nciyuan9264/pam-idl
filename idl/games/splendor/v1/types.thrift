namespace go pam.games.splendor.v1
namespace js pam.games.splendor.v1

include "../../common/v1/room.thrift"

// ---------- 游戏状态（game_status）----------

struct NormalCard {
  1: required i32 id,
  2: required i32 level,             // 1/2/3
  3: required string bonus,          // 折扣颜色：Red/Green/White/Blue/Black
  4: required i32 points,            // 荣誉分
  5: required map<string, i32> cost, // 五色费用
  6: required i32 state,             // 0:牌堆 1:桌面明牌 2:已购买
}

struct NobleCard {
  1: required string id,             // e.g. "N1"
  2: required map<string, i32> cost, // 迎接条件
  3: required i32 points,            // 固定 3 分
  4: required i32 state,             // 0:未揭示 1:可迎接 2:已被迎接
}

struct PlayerState {
  1: required list<NormalCard> normalCard,
  2: required list<NobleCard> nobleCard,
  3: required map<string, i32> gem,
  4: required i32 score,
  5: required list<NormalCard> reserveCard,
}

struct LastAction {
  1: required string action,
  2: required string playerID,
  3: optional string payload, // 原始 JSON 字符串
}

struct GameState {
  1: required string currentPlayer,
  2: required string firstPlayer,
  3: required string gameStartTime, // RFC3339 时间字符串
  4: required string roomStatus,    // match/waiting/playing/last_turn/end
  5: required string ownerID,
  6: required i32 maxPlayers,
  7: required map<string, NormalCard> normalCards, // key = strconv.Itoa(card.ID)
  8: required map<string, NobleCard> nobleCards,
  9: required map<string, i32> gems,
  10: required map<string, PlayerState> players,
  11: optional LastAction lastData,
}

struct Room {
  1: required string roomID,
  2: required map<string, room.RoomPlayerConn> connections,
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
