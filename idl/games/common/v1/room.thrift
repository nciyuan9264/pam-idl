namespace go pam.games.common.v1
namespace js pam.games.common.v1

// 房间公共契约。仅放置所有游戏语义与字段编号一致的结构。

struct RoomPlayer {
  1: required string playerID,
  2: required bool online,
  3: required bool ai,
  4: required bool ready,
}

struct RoomInfo {
  1: required string roomID,
  2: required string status,
  3: required string ownerID,
  4: required list<RoomPlayer> roomPlayer,
  5: optional i32 maxPlayers,
  6: optional i32 emptyTileCount,
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

struct RoomPlayerConn {
  1: required string playerID,
  2: required bool online,
  3: required bool ready,
  4: required bool ai,
}
