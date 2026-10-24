namespace go pam.game.platform.v1
namespace js pam.game.platform.v1

typedef string GameType
typedef string Visibility
typedef string ISODateTime
typedef string CommandType

struct EmptyPayload {}

struct PageInfo {
  1: required i32 limit,
  2: required i32 offset,
  3: required bool hasMore,
  4: optional i32 nextOffset,
  5: required i32 total,
}

struct RealtimeEffect {
  1: required string type,
  2: optional string value,
}

struct ReplayEvent {
  1: required i32 seq,
  2: required string playerID,
  3: required string cmdType,
  4: optional string payloadJSON,
  5: optional string displayName,
}

exception GamePlatformError {
  1: required string code,
  2: required string message,
}
