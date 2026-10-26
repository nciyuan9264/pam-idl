namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string WarChestSide
typedef string WarChestUnitType
typedef string WarChestSetupMode
typedef string WarChestGameStatus
typedef string WarChestActionType
typedef string WarChestPendingKind

struct WarChestDraftState {
  1: required list<WarChestUnitType> pool,
  2: required list<WarChestUnitType> availableUnits,
  3: required list<WarChestUnitType> pickedUnits,
  4: required map<string, list<WarChestUnitType>> rosters,
  5: required string firstPickerID,
  6: optional string currentPickerID,
  7: required i32 currentPickCount,
  8: required i32 completedPickCount,
  9: required bool complete,
  10: optional string turnDeadline,
  11: optional i64 turnTimeoutMs,
}

struct WarChestMatchSetup {
  1: required WarChestSetupMode mode,
  2: required map<string, WarChestSide> sides,
  3: required map<string, list<WarChestUnitType>> rosters,
  4: optional WarChestDraftState draft,
  5: required bool complete,
  6: optional string initialPlayerID,
  7: optional WarChestSide initialSide,
}

struct WarChestCoinView {
  1: required string coinID,
  2: optional WarChestUnitType unitType,
  3: required bool faceUp,
}

struct WarChestUnitStack {
  1: required string unitID,
  2: required WarChestUnitType unitType,
  3: required WarChestSide side,
  4: required string cell,
  5: required i32 coinCount,
}

struct WarChestControl {
  1: required string cell,
  2: required WarChestSide side,
}

struct WarChestDiscardView {
  1: required string coinID,
  2: optional WarChestUnitType unitType,
  3: required bool faceUp,
}

struct WarChestPlayerState {
  1: required WarChestSide side,
  2: required list<WarChestUnitType> roster,
  3: required i32 controlledLocations,
  4: required i32 bagCount,
  5: required i32 handCount,
  6: required map<WarChestUnitType, i32> supply,
  7: required list<WarChestDiscardView> discard,
  8: required map<WarChestUnitType, i32> lost,
}

struct WarChestLegalAction {
  1: required string actionID,
  2: required WarChestActionType action,
  3: optional string coinID,
  4: optional string actorUnitID,
  5: optional string sourceUnitID,
  6: optional string from,
  7: optional string to,
  8: optional string targetUnitID,
  9: optional WarChestUnitType recruitUnit,
  10: optional string after,
  11: optional string defense,
  12: optional WarChestActionType maneuver,
  13: optional list<string> path,
}

struct WarChestPendingDecision {
  1: required WarChestPendingKind kind,
  2: required string playerID,
  3: required WarChestSide side,
  4: optional string actorUnitID,
  5: optional string sourceUnitID,
  6: optional string targetUnitID,
  7: optional string coinID,
  8: optional WarChestUnitType unitType,
  9: optional list<string> remainingUnitIDs,
  10: optional string description,
}

struct WarChestActionEntry {
  1: required i32 id,
  2: required i32 roundNo,
  3: required string playerID,
  4: required WarChestSide side,
  5: required WarChestActionType action,
  6: optional string coinID,
  7: optional WarChestUnitType unitType,
  8: optional string actorUnitID,
  9: optional string sourceUnitID,
  10: optional string from,
  11: optional string to,
  12: optional string targetUnitID,
  13: optional WarChestUnitType targetUnitType,
  14: optional WarChestUnitType recruitUnit,
  15: optional string after,
  16: optional string defense,
  17: optional WarChestActionType maneuver,
  18: optional list<string> path,
  19: required bool automatic,
  20: optional bool private,
  21: optional string summary,
}

struct WarChestRoomData {
  1: required list<WarChestUnitStack> board,
  2: required list<WarChestControl> controls,
  3: required string currentPlayer,
  4: required WarChestSide currentSide,
  5: required string initiativePlayer,
  6: required WarChestSide initiativeSide,
  7: required i32 roundNo,
  8: required WarChestGameStatus gameStatus,
  9: optional WarChestPendingDecision pending,
  10: required list<WarChestLegalAction> legalActions,
  11: optional WarChestActionEntry lastData,
  12: required list<WarChestActionEntry> activityLog,
  13: optional string turnDeadline,
  14: optional i64 turnTimeoutMs,
  15: required map<string, room.RoomPlayer> players,
  16: required list<string> playerOrder,
}

struct WarChestPrivateData {
  1: required list<WarChestCoinView> hand,
  2: required map<WarChestUnitType, i32> bagCounts,
  3: optional list<WarChestCoinView> bagOrder,
}

struct WarChestResult {
  1: required string winnerID,
  2: required WarChestSide winnerSide,
  3: required string reason,
  4: required map<string, i32> controlledLocations,
  5: required i32 roundNo,
  6: required i32 actionCount,
}

struct WarChestRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, WarChestPlayerState> playerData,
  5: required WarChestRoomData roomData,
  6: required WarChestPrivateData privateData,
  7: optional WarChestResult result,
}

struct WarChestReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required WarChestRoomData roomData,
  5: required map<string, WarChestPlayerState> playersData,
  6: required map<string, WarChestPrivateData> privateData,
  7: required WarChestResult result,
}

struct WarChestSetSetupModePayload {
  1: required WarChestSetupMode mode,
}

struct WarChestDraftUnitPayload {
  1: required WarChestUnitType unitType,
}

struct WarChestPlayActionPayload {
  1: required string actionID,
}

union WarChestCommandPayload {
  1: WarChestSetSetupModePayload setSetupMode,
  2: WarChestDraftUnitPayload draftUnit,
  3: WarChestPlayActionPayload playAction,
  4: types.EmptyPayload resign,
}
