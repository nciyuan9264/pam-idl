namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string YinshSide

struct YinshMoveOption {
  1: required string to,
  2: required list<string> flips,
}

struct YinshRow {
  1: required string id,
  2: required list<string> points,
  3: required YinshSide owner,
}

struct YinshPlayerState {
  1: required YinshSide side,
  2: required i32 ringsRemoved,
}

struct YinshLastAction {
  1: required string action,
  2: required string playerID,
  3: optional string payloadJSON,
}

struct YinshRoomData {
  1: required map<string, YinshSide> rings,
  2: required map<string, YinshSide> markers,
  3: required string currentPlayer,
  4: optional string moverPlayer,
  5: optional string resolverPlayer,
  6: required string gameStatus,
  7: required map<YinshSide, i32> placedRings,
  8: required i32 markerPool,
  9: required map<string, list<YinshMoveOption>> legalMoves,
  10: required list<YinshRow> candidateRows,
  11: optional YinshLastAction lastAction,
  12: optional string turnDeadline,
  13: optional i64 turnTimeoutMs,
  14: required map<string, room.RoomPlayer> players,
  15: required list<string> playerOrder,
  16: required i32 roundNo,
}

struct YinshResult {
  1: optional string winnerID,
  2: required string reason,
  3: required map<YinshSide, i32> ringsRemoved,
}

struct YinshRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, YinshPlayerState> playerData,
  5: required YinshRoomData roomData,
  6: optional YinshResult result,
}

struct YinshReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required YinshRoomData roomData,
  5: required map<string, YinshPlayerState> playersData,
  6: required YinshResult result,
}

struct YinshPlaceRingPayload {
  1: required string pointID,
}

struct YinshMoveRingPayload {
  1: required string from,
  2: required string to,
}

struct YinshRemoveRowPayload {
  1: required string rowID,
}

struct YinshRemoveRingPayload {
  1: required string pointID,
}

union YinshCommandPayload {
  1: YinshPlaceRingPayload placeRing,
  2: YinshMoveRingPayload moveRing,
  3: YinshRemoveRowPayload removeRow,
  4: YinshRemoveRingPayload removeRing,
  5: types.EmptyPayload resign,
}
