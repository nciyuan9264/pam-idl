namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string HexSide
typedef string HexGameStatus
typedef string HexActionKind

struct HexCell {
  1: required i32 row,
  2: required i32 column,
}

struct HexActionEntry {
  1: required i32 id,
  2: required HexActionKind kind,
  3: required string playerID,
  4: required HexSide side,
  5: optional HexCell cell,
  6: required bool automatic,
}

struct HexPlayerState {
  1: required HexSide side,
  2: required i32 stoneCount,
}

struct HexRoomData {
  1: required i32 boardSize,
  2: required list<HexSide> board,
  3: required string currentPlayer,
  4: required HexSide currentSide,
  5: required string redPlayerID,
  6: required string tealPlayerID,
  7: required string firstPlayerID,
  8: required i32 roundNo,
  9: required HexGameStatus gameStatus,
  10: required bool pieRule,
  11: required bool swapAvailable,
  12: required list<HexCell> legalMoves,
  13: required list<HexCell> winningPath,
  14: required list<HexActionEntry> moveLog,
  15: optional HexActionEntry lastAction,
  16: optional string turnDeadline,
  17: optional i64 turnTimeoutMs,
  18: required map<string, room.RoomPlayer> players,
  19: required list<string> playerOrder,
}

struct HexResult {
  1: optional string winnerID,
  2: optional HexSide winnerSide,
  3: required string reason,
  4: required i32 turnCount,
  5: required i32 pathLength,
  6: required i32 redStoneCount,
  7: required i32 tealStoneCount,
}

struct HexRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, HexPlayerState> playerData,
  5: required HexRoomData roomData,
  6: optional HexResult result,
}

struct HexReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required HexRoomData roomData,
  5: required map<string, HexPlayerState> playersData,
  6: optional HexResult result,
}

struct HexPlaceStonePayload {
  1: required HexCell cell,
}

union HexCommandPayload {
  1: HexPlaceStonePayload placeStone,
  2: types.EmptyPayload swap,
  3: types.EmptyPayload resign,
}
