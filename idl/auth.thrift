namespace go auth
namespace js auth

struct BaseResp {
  1: required i32 status_code,
  2: required string message,
}

struct SendCodeReq {
  1: required string email (api.format = "email"),
}

struct VerifyCodeReq {
  1: required string email (api.format = "email"),
  2: required string code,
}

struct UpdateUserReq {
  1: optional i64 user_id,
  2: optional string email,
  3: optional string name,
  4: optional string avatar,
}

struct AuthUser {
  1: required i64 id,
  2: optional string email,
  3: optional string avatar,
  4: optional string name,
}

struct AuthCenterResp {
  1: required i32 status_code,
  2: required string message,
  3: required AuthUser data,
}

struct UploadAvatarData {
  1: required string avatar,
  2: required string url,
}

struct UploadAvatarReq {
  1: required binary avatar (api.form = "avatar"),
}

struct UploadAvatarResp {
  1: required i32 status_code,
  2: required string message,
  3: required UploadAvatarData data,
}

service AuthService {
  BaseResp SendCode(1: required SendCodeReq req) (
    api.post = "/auth/send-code",
    api.operation_id = "sendCode",
    api.summary = "发送验证码"
  )

  BaseResp VerifyCode(1: required VerifyCodeReq req) (
    api.post = "/auth/verify-code",
    api.operation_id = "verifyCode",
    api.summary = "验证验证码并登录"
  )

  BaseResp Refresh() (
    api.post = "/auth/refresh",
    api.operation_id = "refresh",
    api.summary = "刷新 token"
  )

  AuthCenterResp VerifyToken() (
    api.post = "/auth/verify-token",
    api.operation_id = "verifyToken",
    api.summary = "验证 token"
  )

  BaseResp Logout() (
    api.post = "/auth/logout",
    api.operation_id = "logout",
    api.summary = "退出登录",
    api.auth_required = "true"
  )

  AuthCenterResp GetProfile() (
    api.get = "/auth/profile",
    api.operation_id = "getProfile",
    api.summary = "获取当前用户资料",
    api.auth_required = "true"
  )

  BaseResp UpdateUser(1: required UpdateUserReq req) (
    api.post = "/auth/update",
    api.operation_id = "updateUser",
    api.summary = "更新用户资料",
    api.auth_required = "true"
  )

  UploadAvatarResp UploadAvatar(1: required UploadAvatarReq req) (
    api.post = "/auth/avatar/upload",
    api.operation_id = "uploadAvatar",
    api.summary = "上传头像",
    api.auth_required = "true",
    api.content_type = "multipart/form-data"
  )
}
