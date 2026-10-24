namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

include "room.thrift"

struct DavinciCard {
  1: required string id,
  2: required i32 color,
  3: optional i32 num,
  4: optional bool isRevealed,
  5: optional i32 index,
}

struct DavinciLastGuessPayload {
  1: required string targetCardID,
  2: required string targetPlayerID,
  3: required i32 guessNum,
  4: required bool correct,
}

struct DavinciLastAction {
  1: required string action,
  2: required string playerID,
  3: optional DavinciLastGuessPayload payload,
}

struct DavinciRoomData {
  1: required string currentPlayer,
  2: required string gameStatus,
  3: required map<string, room.RoomPlayer> players,
  4: required list<string> playerOrder,
  5: required map<string, DavinciCard> boardCards,
  6: optional DavinciLastAction lastData,
  7: optional string turnDeadline,
  8: optional i64 turnTimeoutMs,
}

struct DavinciCardData {
  1: required list<DavinciCard> self,
  2: required list<DavinciCard> opponents,
  3: optional bool initialHandReady,
}

struct DavinciResult {
  1: required string winnerID,
}

struct DavinciRoomView {
  1: required string playerId,
  2: required string ownerID,
  3: required DavinciRoomData roomData,
  4: required DavinciCardData cardData,
  5: optional DavinciResult result,
}

struct DavinciGetCardPayload {
  1: required string id,
}

struct DavinciGuessCardPayload {
  1: required string id,
  2: required i32 num,
}

struct DavinciSetCardPayload {
  1: required string id,
  2: required i32 index,
}

struct DavinciJokerPlacement {
  1: required string id,
  2: required i32 index,
}

struct DavinciInitializeHandPayload {
  1: required list<DavinciJokerPlacement> jokerPlacements,
}

union DavinciCommandPayload {
  1: DavinciGetCardPayload getCard,
  2: DavinciGuessCardPayload guessCard,
  3: DavinciSetCardPayload setCard,
  4: DavinciInitializeHandPayload initializeHand,
}
