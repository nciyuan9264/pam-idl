namespace go pam.auth.v1
namespace js pam.auth.v1

struct UserIdentity {
  1: required string user_id,
  2: optional string email,
  3: optional string name,
  4: optional string display_name,
  5: optional string avatar,
  6: optional list<string> roles,
}

struct EmptyData {}

struct BaseResp {
  1: required i32 status_code,
  2: required string message,
  3: optional EmptyData data,
}

struct RegisterReq {
  1: required string email (api.format = "email"),
  2: required string password,
}

struct SendCodeReq {
  1: required string email (api.format = "email"),
}

struct SendCodeData {
  1: optional string dev_code,
}

struct SendCodeResp {
  1: required i32 status_code,
  2: required string message,
  3: optional SendCodeData data,
}

struct LoginShowcaseReq {}

struct LoginShowcasePlayer {
  1: required string avatar,
}

struct LoginShowcaseData {
  1: required i64 total_players,
  // Number of players created during the previous seven days.
  2: required i64 newly_joined_players,
  3: required list<LoginShowcasePlayer> recent_players,
}

struct LoginShowcaseResp {
  1: required i32 status_code,
  2: required string message,
  3: required LoginShowcaseData data,
}

struct LoginByPasswordReq {
  1: required string email (api.format = "email"),
  2: required string password,
}

struct LoginByCodeReq {
  1: required string email (api.format = "email"),
  2: required string code,
}

struct VerifyTokenReq {
  1: required string access_token (api.none = "true"),
  2: optional string required_audience (api.none = "true"),
}

struct VerifyTokenData {
  1: required bool valid,
  2: optional UserIdentity user,
  3: optional string token_id,
  4: optional i64 expires_at_unix,
  5: optional string reason,
}

struct VerifyTokenResp {
  1: required i32 status_code,
  2: required string message,
  3: required VerifyTokenData data,
}

struct RefreshTokenReq {
  1: required string refresh_token (api.none = "true"),
}

struct LogoutReq {
  1: optional string access_token (api.none = "true"),
  2: optional string refresh_token (api.none = "true"),
}

struct GetProfileReq {
  1: required string access_token (api.none = "true"),
}

struct UserResp {
  1: required i32 status_code,
  2: required string message,
  3: required UserIdentity data,
  4: optional bool needs_onboarding,
}

struct UpdateUserReq {
  1: required string access_token (api.none = "true"),
  2: optional string email (api.body = "email"),
  3: optional string name (api.body = "name"),
  4: optional string avatar (api.body = "avatar"),
}

struct UploadAvatarReq {
  1: required string access_token (api.none = "true"),
  2: required binary content (api.form = "avatar"),
  3: optional string file_name (api.none = "true"),
  4: optional string content_type (api.none = "true"),
}

struct UploadAvatarData {
  1: required string avatar,
  2: required string url,
}

struct UploadAvatarResp {
  1: required i32 status_code,
  2: required string message,
  3: required UploadAvatarData data,
}

struct GetUserReq {
  1: required string user_id,
}

struct AuthUserRecord {
  1: required UserIdentity identity,
  2: required i64 created_at_unix,
  3: required i64 updated_at_unix,
}

struct ListUsersReq {
  1: optional i32 page_size,
  2: optional string page_token,
}

struct ListUsersData {
  1: required list<AuthUserRecord> users,
  2: optional string next_page_token,
}

struct ListUsersResp {
  1: required i32 status_code,
  2: required string message,
  3: required ListUsersData data,
}

struct JWKSReq {}

struct JWKSData {
  1: required string jwks_json,
}

struct JWKSResp {
  1: required i32 status_code,
  2: required string message,
  3: required JWKSData data,
}

struct PasskeyRecord {
  1: required string passkey_id,
  2: required string name,
  3: required i64 created_at_unix,
  4: optional i64 last_used_at_unix,
  5: optional bool backup_eligible,
  6: optional bool backed_up,
}

struct ListPasskeysReq {}

struct ListPasskeysData {
  1: required bool enabled,
  2: required string rp_id,
  3: required i32 max_passkeys,
  4: required list<PasskeyRecord> passkeys,
}

struct ListPasskeysResp {
  1: required i32 status_code,
  2: required string message,
  3: required ListPasskeysData data,
}

struct SendPasskeyManagementCodeReq {
  1: required string purpose (api.body = "purpose"),
  2: optional string passkey_id (api.body = "passkey_id"),
}

struct PasskeyManagementCodeData {
  1: required string operation_id,
  2: required i64 expires_at_unix,
  3: required i32 resend_after_seconds,
}

struct PasskeyManagementCodeResp {
  1: required i32 status_code,
  2: required string message,
  3: required PasskeyManagementCodeData data,
}

struct BeginPasskeyRegistrationReq {
  1: required string operation_id (api.body = "operation_id"),
  2: required string code (api.body = "code"),
  3: required string name (api.body = "name"),
}

struct PasskeyCeremonyData {
  1: required string ceremony_id,
  2: required string public_key_options_json,
  3: required i64 expires_at_unix,
}

struct PasskeyCeremonyResp {
  1: required i32 status_code,
  2: required string message,
  3: required PasskeyCeremonyData data,
}

struct FinishPasskeyRegistrationReq {
  1: required string ceremony_id (api.body = "ceremony_id"),
  2: required string credential_json (api.body = "credential_json"),
}

struct PasskeyData {
  1: required PasskeyRecord passkey,
}

struct PasskeyResp {
  1: required i32 status_code,
  2: required string message,
  3: required PasskeyData data,
}

struct BeginPasskeyLoginReq {}

struct FinishPasskeyLoginReq {
  1: required string ceremony_id (api.body = "ceremony_id"),
  2: required string credential_json (api.body = "credential_json"),
}

struct RenamePasskeyReq {
  1: required string passkey_id (api.path = "passkey_id"),
  2: required string name (api.body = "name"),
}

struct DeletePasskeyReq {
  1: required string passkey_id (api.path = "passkey_id"),
  2: required string operation_id (api.body = "operation_id"),
  3: required string code (api.body = "code"),
}

exception AuthError {
  1: required string code,
  2: required string message,
}
