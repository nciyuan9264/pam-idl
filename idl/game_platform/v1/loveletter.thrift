namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"
include "types.thrift"

typedef string LoveLetterGameStatus
typedef string LoveLetterActionKind
typedef string LoveLetterPrivateEffectKind

struct LoveLetterCard {
  1: required string cardID,
  2: required i32 rank,
}

struct LoveLetterPlayerState {
  1: required i32 favors,
  2: required bool alive,
  3: required bool protected,
  4: required bool spyUsed,
  5: required i32 handCount,
  6: required list<LoveLetterCard> discards,
}

struct LoveLetterPrivateEffect {
  1: required string effectID,
  2: required LoveLetterPrivateEffectKind kind,
  3: optional string targetPlayerID,
  4: optional i32 targetRank,
  5: optional i32 actorRank,
  6: optional string summary,
}

struct LoveLetterPrivateData {
  1: required list<LoveLetterCard> hand,
  2: required list<string> legalCardIDs,
  3: required map<string, list<string>> legalTargets,
  4: required list<i32> guardGuessRanks,
  5: optional LoveLetterPrivateEffect effect,
}

struct LoveLetterActionEntry {
  1: required i32 id,
  2: required i32 roundNo,
  3: required LoveLetterActionKind kind,
  4: required string playerID,
  5: optional i32 cardRank,
  6: optional string targetPlayerID,
  7: optional i32 guessRank,
  8: optional bool success,
  9: required bool automatic,
  10: optional bool private,
  11: optional string summary,
}

struct LoveLetterRoundResult {
  1: required list<string> winnerIDs,
  2: optional string spyPlayerID,
  3: required string reason,
  4: required map<string, i32> favorsBefore,
  5: required map<string, i32> favorsAfter,
  6: required map<string, LoveLetterCard> revealedHands,
  7: required list<string> matchWinnerIDs,
}

struct LoveLetterResult {
  1: required list<string> winnerIDs,
  2: required map<string, i32> favors,
  3: required map<string, i32> finalRanks,
  4: required i32 roundNo,
  5: required string reason,
}

struct LoveLetterRoomData {
  1: required string currentPlayer,
  2: required LoveLetterGameStatus gameStatus,
  3: required i32 roundNo,
  4: required i32 goal,
  5: required i32 deckCount,
  6: required i32 reserveCount,
  7: required list<LoveLetterCard> burnCards,
  8: required list<LoveLetterActionEntry> activityLog,
  9: optional LoveLetterActionEntry lastData,
  10: optional LoveLetterRoundResult roundResult,
  11: optional string turnDeadline,
  12: optional i64 turnTimeoutMs,
  13: optional string roundTransitionDeadline,
  14: required map<string, room.RoomPlayer> players,
  15: required list<string> playerOrder,
}

struct LoveLetterRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required string visibility,
  4: required map<string, LoveLetterPlayerState> playerData,
  5: required LoveLetterRoomData roomData,
  6: required LoveLetterPrivateData privateData,
  7: optional LoveLetterResult result,
}

struct LoveLetterReplaySnapshot {
  1: required i32 seq,
  2: required i32 totalEvents,
  3: optional types.ReplayEvent currentEvent,
  4: required LoveLetterRoomData roomData,
  5: required map<string, LoveLetterPlayerState> playersData,
  6: required map<string, LoveLetterPrivateData> privateData,
  7: required list<LoveLetterCard> deck,
  8: optional LoveLetterCard reserve,
  9: optional LoveLetterResult result,
}

struct LoveLetterPlayCardPayload {
  1: required string cardID,
  2: optional string targetPlayerID,
  3: optional i32 guessRank,
}

struct LoveLetterSettleChancellorPayload {
  1: required string keepCardID,
  2: required list<string> bottomCardIDs,
}

union LoveLetterCommandPayload {
  1: types.EmptyPayload drawCard,
  2: LoveLetterPlayCardPayload playCard,
  3: LoveLetterSettleChancellorPayload settleChancellor,
  4: types.EmptyPayload nextRound,
}
