namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string SixNimmtGameStatus
typedef string SixNimmtPlacementKind
typedef string SixNimmtActionKind
typedef string SixNimmtAutomationKind

struct SixNimmtRow {
  1: required i32 index,
  2: required list<i32> cards,
  3: required i32 bullheads,
}

struct SixNimmtPlayerState {
  1: required i32 roundPenalty,
  2: required i32 totalPenalty,
  3: required i32 handCount,
  4: required i32 takenCount,
  5: required bool locked,
}

struct SixNimmtPrivateData {
  1: required list<i32> hand,
  2: required list<i32> legalCards,
  3: optional i32 lockedCard,
}

struct SixNimmtSelection {
  1: required string playerID,
  2: required i32 card,
  3: optional SixNimmtAutomationKind automationKind,
}

struct SixNimmtPlacement {
  1: required string playerID,
  2: required i32 card,
  3: required i32 rowIndex,
  4: required SixNimmtPlacementKind kind,
  5: required list<i32> collectedCards,
  6: required i32 penalty,
  7: optional SixNimmtAutomationKind automationKind,
}

struct SixNimmtTurnResolution {
  1: required string resolutionID,
  2: required i32 roundNo,
  3: required i32 turnNo,
  4: required list<SixNimmtRow> rowsBefore,
  5: required list<SixNimmtSelection> selections,
  6: required list<SixNimmtPlacement> placements,
  7: required list<SixNimmtRow> rowsAfter,
  8: required bool complete,
}

struct SixNimmtPendingChoice {
  1: required string playerID,
  2: required i32 card,
  3: required list<i32> rowPenalties,
}

struct SixNimmtActionEntry {
  1: required i32 id,
  2: required i32 roundNo,
  3: required i32 turnNo,
  4: required SixNimmtActionKind kind,
  5: required string playerID,
  6: optional i32 card,
  7: optional i32 rowIndex,
  8: optional i32 penalty,
  9: optional SixNimmtAutomationKind automationKind,
  10: optional string summary,
}

struct SixNimmtRoundResult {
  1: required i32 roundNo,
  2: required map<string, i32> roundPenalties,
  3: required map<string, i32> totalPenalties,
  4: required bool thresholdReached,
  5: optional string nextRoundDeadline,
}

struct SixNimmtResult {
  1: required list<string> winnerIDs,
  2: required map<string, i32> totalPenalties,
  3: required map<string, i32> finalRanks,
  4: required i32 roundNo,
  5: required string reason,
}

struct SixNimmtRoomData {
  1: required SixNimmtGameStatus gameStatus,
  2: required i32 roundNo,
  3: required i32 turnNo,
  4: required list<SixNimmtRow> rows,
  5: required list<string> lockedPlayerIDs,
  6: required list<SixNimmtActionEntry> activityLog,
  7: optional SixNimmtTurnResolution lastResolution,
  8: optional SixNimmtPendingChoice pendingChoice,
  9: optional SixNimmtRoundResult roundResult,
  10: optional string turnDeadline,
  11: optional i64 turnTimeoutMs,
  12: optional string roundTransitionDeadline,
  13: required map<string, room.RoomPlayer> players,
  14: required list<string> playerOrder,
}

struct SixNimmtRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, SixNimmtPlayerState> playerData,
  5: required SixNimmtPrivateData privateData,
  6: required SixNimmtRoomData roomData,
  7: optional SixNimmtResult result,
}

struct SixNimmtReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required SixNimmtRoomData roomData,
  5: required map<string, SixNimmtPlayerState> playersData,
  6: required map<string, SixNimmtPrivateData> privateData,
  7: required list<i32> unusedCards,
  8: optional SixNimmtResult result,
}

struct SixNimmtLockCardPayload {
  1: required i32 card,
}

struct SixNimmtChooseRowPayload {
  1: required i32 rowIndex,
}

union SixNimmtCommandPayload {
  1: SixNimmtLockCardPayload lockCard,
  2: types.EmptyPayload unlockCard,
  3: SixNimmtChooseRowPayload chooseRow,
  4: types.EmptyPayload nextRound,
}
