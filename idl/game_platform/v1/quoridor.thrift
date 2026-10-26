namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string QuoridorSide
typedef string QuoridorOrientation

struct QuoridorCell {
  1: required i32 row,
  2: required i32 column,
}

struct QuoridorWallSpec {
  1: required i32 row,
  2: required i32 column,
  3: required QuoridorOrientation orientation,
}

struct QuoridorWall {
  1: required i32 row,
  2: required i32 column,
  3: required QuoridorOrientation orientation,
  4: required QuoridorSide side,
}

struct QuoridorWallOption {
  1: required i32 row,
  2: required i32 column,
  3: required QuoridorOrientation orientation,
  4: required bool legal,
  5: optional string reasonCode,
}

struct QuoridorActionEntry {
  1: required i32 id,
  2: required string kind,
  3: required string playerID,
  4: required QuoridorSide side,
  5: optional QuoridorCell from,
  6: optional QuoridorCell to,
  7: optional QuoridorWallSpec wall,
  8: required bool automatic,
}

struct QuoridorPlayerState {
  1: required QuoridorSide side,
  2: required i32 wallsRemaining,
  3: required i32 distanceToGoal,
}

struct QuoridorRoomData {
  1: required map<QuoridorSide, QuoridorCell> pawns,
  2: required list<QuoridorWall> walls,
  3: required map<QuoridorSide, i32> wallStock,
  4: required string currentPlayer,
  5: required QuoridorSide currentSide,
  6: required string southPlayerID,
  7: required string northPlayerID,
  8: required string firstPlayerID,
  9: required i32 roundNo,
  10: required string gameStatus,
  11: required list<QuoridorCell> legalMoves,
  12: required list<QuoridorWallOption> wallOptions,
  13: required map<QuoridorSide, list<QuoridorCell>> referencePaths,
  14: required list<QuoridorActionEntry> moveLog,
  15: optional QuoridorActionEntry lastAction,
  16: optional string turnDeadline,
  17: optional i64 turnTimeoutMs,
  18: required map<string, room.RoomPlayer> players,
  19: required list<string> playerOrder,
}

struct QuoridorResult {
  1: optional string winnerID,
  2: optional QuoridorSide winnerSide,
  3: required string reason,
  4: required i32 turnCount,
  5: required i32 placedWallCount,
}

struct QuoridorRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, QuoridorPlayerState> playerData,
  5: required QuoridorRoomData roomData,
  6: optional QuoridorResult result,
}

struct QuoridorReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required QuoridorRoomData roomData,
  5: required map<string, QuoridorPlayerState> playersData,
  6: required QuoridorResult result,
}

struct QuoridorMovePawnPayload {
  1: required QuoridorCell to,
}

struct QuoridorPlaceWallPayload {
  1: required QuoridorWallSpec wall,
}

union QuoridorCommandPayload {
  1: QuoridorMovePawnPayload movePawn,
  2: QuoridorPlaceWallPayload placeWall,
  3: types.EmptyPayload resign,
}
