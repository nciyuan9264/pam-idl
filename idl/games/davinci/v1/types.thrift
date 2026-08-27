namespace go pam.games.davinci.v1
namespace js pam.games.davinci.v1

include "../../common/v1/room.thrift"

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
