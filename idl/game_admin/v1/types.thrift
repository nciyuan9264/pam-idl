namespace go pam.game.admin.v1
namespace js pam.game.admin.v1

typedef string ISODate

struct EmptyReq {}

struct OverviewReq {
  1: optional ISODate start_date (api.query = "start_date"),
  2: optional ISODate end_date (api.query = "end_date"),
}

exception GameAdminError {
  1: required string code,
  2: required string message,
}

struct AnalyticsWindow {
  1: required string timezone,
  2: required ISODate start_date,
  3: required ISODate end_date,
  4: required i32 days,
  5: required i64 generated_at_unix,
}

struct OverviewMetrics {
  1: required i64 total_users,
  2: required i64 new_users,
  3: required i64 dau,
  4: required i64 wau,
  5: required i64 mau,
  6: required double dau_mau_rate,
  7: required double first_match_conversion_rate,
  8: required double d1_retention_rate,
  9: required double d7_retention_rate,
  10: required double d30_retention_rate,
  11: required i64 games_started,
  12: required i64 games_completed,
  13: required double completion_rate,
  14: required i64 game_duration_seconds,
  15: required i64 player_duration_seconds,
  16: required i64 average_game_duration_seconds,
  17: required i64 average_player_duration_seconds,
  18: required i64 games_abandoned,
}

struct DailyOverview {
  1: required ISODate date,
  2: required i64 new_users,
  3: required i64 active_users,
  4: required i64 games_started,
  5: required i64 games_completed,
  6: required i64 game_duration_seconds,
  7: required i64 player_duration_seconds,
  8: required i64 games_abandoned,
}

struct OverviewData {
  1: required AnalyticsWindow window,
  2: required OverviewMetrics metrics,
  3: required list<DailyOverview> daily,
}

struct OverviewResp {
  1: required i32 status_code,
  2: required string message,
  3: required OverviewData data,
}

struct ListUsersReq {
  1: optional i32 page (api.query = "page"),
  2: optional i32 page_size (api.query = "page_size"),
  3: optional string query (api.query = "query"),
}

struct AdminUserSummary {
  1: required string user_id,
  2: required string display_name,
  3: optional string email,
  4: optional string avatar,
  5: required i64 created_at_unix,
  6: optional ISODate first_active_date,
  7: optional i64 last_active_at_unix,
  8: required i64 active_days,
  9: required i64 games_played,
  10: required i64 player_duration_seconds,
  11: optional string favorite_game_type,
}

struct UsersData {
  1: required AnalyticsWindow window,
  2: required list<AdminUserSummary> users,
  3: required i32 page,
  4: required i32 page_size,
  5: required i64 total,
}

struct UsersResp {
  1: required i32 status_code,
  2: required string message,
  3: required UsersData data,
}

struct GetUserActivityReq {
  1: required string user_id (api.path = "user_id"),
}

struct UserDailyActivity {
  1: required ISODate date,
  2: required i64 games_played,
  3: required i64 player_duration_seconds,
}

struct UserGameActivity {
  1: required string game_type,
  2: required i64 games_played,
  3: required i64 active_days,
  4: required i64 player_duration_seconds,
  5: required double share_rate,
}

struct UserActivityData {
  1: required AnalyticsWindow window,
  2: required AdminUserSummary user,
  3: required list<UserDailyActivity> daily,
  4: required list<UserGameActivity> games,
}

struct UserActivityResp {
  1: required i32 status_code,
  2: required string message,
  3: required UserActivityData data,
}

struct GameActivitySummary {
  1: required string game_type,
  2: required i64 active_users,
  3: required i64 games_started,
  4: required i64 games_completed,
  5: required double completion_rate,
  6: required i64 game_duration_seconds,
  7: required i64 player_duration_seconds,
  8: required i64 average_game_duration_seconds,
  9: required double average_human_players,
  10: required i64 games_abandoned,
}

struct GamesData {
  1: required AnalyticsWindow window,
  2: required list<GameActivitySummary> games,
}

struct GamesResp {
  1: required i32 status_code,
  2: required string message,
  3: required GamesData data,
}

struct LiveGameSummary {
  1: required string game_type,
  2: required i64 active_rooms,
  3: required i64 active_matches,
  4: required i64 online_players,
}

struct LiveRoomSummary {
  1: required string room_id,
  2: required string match_id,
  3: required string game_type,
  4: required string status,
  5: required i64 human_players,
  6: required i64 online_players,
  7: required i64 started_at_unix,
}

struct LiveData {
  1: required i64 generated_at_unix,
  2: required i64 active_rooms,
  3: required i64 active_matches,
  4: required i64 online_players,
  5: required list<LiveGameSummary> games,
  6: required list<LiveRoomSummary> rooms,
}

struct LiveResp {
  1: required i32 status_code,
  2: required string message,
  3: required LiveData data,
}
