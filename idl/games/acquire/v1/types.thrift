namespace go pam.games.acquire.v1
namespace js pam.games.acquire.v1

include "../../common/v1/room.thrift"

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
