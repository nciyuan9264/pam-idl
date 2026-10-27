namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string CantStopGameStatus
typedef string CantStopActionKind

struct CantStopPairingOption {
  1: required string actionID,
  2: required i32 pairingIndex,
  3: required i32 variantIndex,
  4: required list<i32> sums,
  5: required list<i32> diceIndexes,
  6: required map<i32, i32> advances,
  7: required map<i32, i32> runnerPositions,
  8: required i32 stepCount,
}

struct CantStopPlayerState {
  1: required map<i32, i32> savedProgress,
  2: required list<i32> claimedColumns,
  3: required i32 savedStepCount,
}

struct CantStopActionEntry {
  1: required i32 id,
  2: required i32 turnNumber,
  3: required i32 rollNumber,
  4: required CantStopActionKind kind,
  5: required string playerID,
  6: optional list<i32> dice,
  7: optional string actionID,
  8: required list<i32> columns,
  9: required i32 gain,
  10: required bool automatic,
  11: optional string summary,
}

struct CantStopRoomData {
  1: required CantStopGameStatus gameStatus,
  2: required string currentPlayer,
  3: required string nextPlayer,
  4: required i32 turnNumber,
  5: required i32 rollNumber,
  6: required list<i32> dice,
  7: required list<CantStopPairingOption> pairingOptions,
  8: required map<i32, i32> runners,
  9: required map<i32, string> claimedBy,
  10: required list<CantStopActionEntry> activityLog,
  11: optional CantStopActionEntry lastAction,
  12: required double bustRisk,
  13: required i32 turnGain,
  14: required i32 lostGain,
  15: optional string turnDeadline,
  16: optional i64 turnTimeoutMs,
  17: optional string turnTransitionDeadline,
  18: required map<string, room.RoomPlayer> players,
  19: required list<string> playerOrder,
}

struct CantStopResult {
  1: required string winnerID,
  2: required list<i32> claimedColumns,
  3: required i32 turnCount,
  4: required i32 rollCount,
  5: required map<string, i32> bustCounts,
  6: required string reason,
}

struct CantStopRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, CantStopPlayerState> playerData,
  5: required CantStopRoomData roomData,
  6: optional CantStopResult result,
}

struct CantStopReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required CantStopRoomData roomData,
  5: required map<string, CantStopPlayerState> playersData,
  6: optional CantStopResult result,
}

struct CantStopAdvancePayload {
  1: required string actionID,
}

union CantStopCommandPayload {
  1: types.EmptyPayload rollDice,
  2: CantStopAdvancePayload advance,
  3: types.EmptyPayload bank,
  4: types.EmptyPayload nextTurn,
}
