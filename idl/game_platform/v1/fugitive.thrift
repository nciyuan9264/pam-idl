namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string FugitiveRole

struct FugitiveCard {
  1: required i32 number,
  2: required i32 sprint,
}

struct FugitiveRouteCard {
  1: required i32 index,
  2: required bool revealed,
  3: required i32 sprintCount,
  4: optional FugitiveCard card,
  5: optional list<FugitiveCard> sprints,
}

struct FugitiveDeckState {
  1: required i32 deckIndex,
  2: required i32 min,
  3: required i32 max,
  4: required i32 remaining,
}

struct FugitiveActionLog {
  1: required i32 id,
  2: required i32 roundNo,
  3: required string kind,
  4: required string playerID,
  5: required FugitiveRole role,
  6: optional i32 deckIndex,
  7: optional list<i32> numbers,
  8: optional i32 destination,
  9: required i32 sprintCount,
  10: optional bool success,
  11: required bool automatic,
  12: optional bool private,
}

struct FugitivePlayerState {
  1: required FugitiveRole role,
  2: required i32 handCount,
}

struct FugitiveRoomData {
  1: required string currentPlayer,
  2: required string gameStatus,
  3: required i32 roundNo,
  4: required i32 drawsRemaining,
  5: required i32 highestRevealed,
  6: required i32 hiddenHideoutCount,
  7: required list<FugitiveRouteCard> route,
  8: required list<FugitiveDeckState> decks,
  9: required list<FugitiveActionLog> activityLog,
  10: optional FugitiveActionLog lastData,
  11: optional string turnDeadline,
  12: optional i64 turnTimeoutMs,
  13: required map<string, room.RoomPlayer> players,
  14: required list<string> playerOrder,
  15: required i32 openingHideoutsPlaced,
}

struct FugitiveResult {
  1: required string winnerID,
  2: required FugitiveRole winnerRole,
  3: required string reason,
  4: required i32 searches,
}

struct FugitiveRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, FugitivePlayerState> playerData,
  5: required FugitiveRoomData roomData,
  6: required list<FugitiveCard> hand,
  7: optional FugitiveResult result,
}

struct FugitiveSelectRolePayload {
  1: required FugitiveRole role,
}

struct FugitiveDrawCardPayload {
  1: required i32 deckIndex,
}

struct FugitivePlayHideoutPayload {
  1: required i32 hideout,
  2: required list<i32> sprints,
}

struct FugitiveSearchHideoutsPayload {
  1: required list<i32> numbers,
}

union FugitiveCommandPayload {
  1: FugitiveSelectRolePayload selectRole,
  2: FugitiveDrawCardPayload drawCard,
  3: FugitivePlayHideoutPayload playHideout,
  4: types.EmptyPayload finishOpening,
  5: types.EmptyPayload layLow,
  6: FugitiveSearchHideoutsPayload searchHideouts,
}
